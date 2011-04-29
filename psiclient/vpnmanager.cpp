/*
 * Copyright (c) 2011, Psiphon Inc.
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "stdafx.h"
#include "vpnmanager.h"
#include "psiclient.h"
#include "webbrowser.h"
#include <algorithm>

VPNManager::VPNManager(void) :
    m_vpnState(VPN_STATE_STOPPED),
    m_userSignalledStop(false)
{
}

VPNManager::~VPNManager(void)
{
    Stop();
}

void VPNManager::Toggle()
{
    switch (m_vpnState)
    {
    case VPN_STATE_STOPPED:
        // The user clicked the button to start the VPN.
        // Clear this flag so we can do retries on failed connections.
        m_userSignalledStop = false;
        TryNextServer();
        break;

    default:
        // The user requested to stop the VPN by clicking the button.
        //
        // If a connection was in the INITIALIZING state, this flag
        // tells TryNextServer not to Establish, or to Stop if
        // Establish was already called.
        // NOTE that Stop is called here in case TryNextServer has
        // already returned (and the first callback notification has
        // not yet been received).
        //
        // If a connection was in the STARTING state, we will get a
        // "Connection Failed" notification.
        // This flag indicates that we should not retry when a failed
        // connection is signalled.
        m_userSignalledStop = true;
        Stop();
        break;
    }
}

void VPNManager::Stop(void)
{
    if (m_vpnConnection.Remove())
    {
        VPNStateChanged(VPN_STATE_STOPPED);
    }
}

void VPNManager::VPNStateChanged(VPNState newState)
{
    m_vpnState = newState;

    switch (m_vpnState)
    {
    case VPN_STATE_CONNECTED:
        if (m_serverInfo.get())
        {
            OpenBrowser(m_serverInfo->GetHomepages());
        }
        break;

    case VPN_STATE_FAILED:
        // Either the user cancelled an in-progress connection,
        // or a connection actually failed.
        // Either way, we need to set the status to STOPPED,
        // so that another Toggle() will cause the VPN to start again.
        m_vpnState = VPN_STATE_STOPPED;

        if (!m_userSignalledStop)
        {
            // Connecting to the current server failed.
            try
            {
                m_vpnList.MarkCurrentServerFailed();
                TryNextServer();
            }
            catch (std::exception &ex)
            {
                my_print(false, string("VPNStateChanged caught exception: ") + ex.what());
            }
        }
        break;

    default:
        // no default actions
        break;
    }
}

void VPNManager::TryNextServer(void)
{
    // This function might not return quickly, because it performs an HTTPS Request.
    // It is run in a thread so that it does not starve the message pump.
    if (!CreateThread(0, 0, TryNextServerThread, (void*)this, 0, 0))
    {
        my_print(false, _T("TryNextServer: CreateThread failed (%d)"), GetLastError());
    }
}

DWORD WINAPI VPNManager::TryNextServerThread(void* object)
{
    VPNManager* This = (VPNManager*)object;
    This->VPNStateChanged(VPN_STATE_INITIALIZING);

    ServerEntry serverEntry;
    try
    {
        // Try the next server in our list.
        serverEntry = This->m_vpnList.GetNextServer();
    }
    catch (std::exception &ex)
    {
        my_print(false, string("TryNextServerThread caught exception: ") + ex.what());
        This->Stop();
        return 0;
    }

#ifdef _UNICODE
    wstring serverAddress(serverEntry.serverAddress.length(), L' ');
    std::copy(serverEntry.serverAddress.begin(), serverEntry.serverAddress.end(), serverAddress.begin());
#else
    string serverAddress = serverEntry.serverAddress;
#endif

    // NOTE: Toggle may have been clicked since the start of this function.
    //       If it was, don't make the web request.
    if (!This->m_userSignalledStop)
    {
        This->m_serverInfo.reset(new ServerInfo(serverEntry));
        if (This->m_serverInfo->DoHandshake())
        {
            try
            {
                This->m_vpnList.AddEntriesToList(This->m_serverInfo->GetDiscoveredServerEntries());
            }
            catch (std::exception &ex)
            {
                my_print(false, string("TryNextServerThread caught exception: ") + ex.what());
                // This isn't fatal.  The VPN connection can still be established.
            }
        }
        else
        {
            This->VPNStateChanged(VPN_STATE_FAILED);
            return 0;
        }
    }

    // NOTE: Toggle may have been clicked during the web request.
    //       If it was, don't Establish the VPN connection.
    if (!This->m_userSignalledStop)
    {
        if (!This->m_vpnConnection.Establish(serverAddress, This->m_serverInfo->GetPSK()))
        {
            This->Stop();
        }
    }

    // NOTE: Toggle may have been clicked during Establish.
    //       If it was, Stop the VPN.
    if (This->m_userSignalledStop)
    {
        This->Stop();
    }

    return 0;
}
