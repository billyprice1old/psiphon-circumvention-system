/**
 * @file cavl_test.c
 * @author Ambroz Bizjak <ambrop7@gmail.com>
 * 
 * @section LICENSE
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the author nor the
 *    names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdint.h>
#include <limits.h>

#include <misc/balloc.h>
#include <misc/compare.h>
#include <misc/debug.h>
#include <misc/print_macros.h>
#include <structure/CAvl.h>

#define USE_COUNTS 0

typedef size_t entry_index;
#define MAX_INDICES SIZE_MAX

typedef uint32_t entry_key;

struct entry {
    entry_index tree_child[2];
    entry_index tree_parent;
    int8_t tree_balance;
#if USE_COUNTS
    size_t tree_count;
#endif
    entry_key key;
};

typedef struct entry *entry_ptr;

#include "cavl_test_tree.h"
#include <structure/CAvl_decl.h>

#include "cavl_test_tree.h"
#include <structure/CAvl_impl.h>

static void random_bytes (char *buf, size_t len)
{
    while (len > 0) {
        *((unsigned char *)buf) = rand();
        buf++;
        len--;
    }
}

int main (int argc, char *argv[])
{
    //srand(time(NULL));
    
    printf("sizeof(struct entry)=%" PRIsz "\n", sizeof(struct entry));
    
    if (argc != 6) {
        fprintf(stderr, "Usage: %s <num_keys> <num_lookups> <num_remove> <do_remove=1/0> <do_verify=1/0>\n", (argc > 0 ? argv[0] : ""));
        return 1;
    }
    
    size_t num_keys = atoi(argv[1]);
    size_t num_lookups = atoi(argv[2]);
    size_t num_remove = atoi(argv[3]);
    size_t do_remove = atoi(argv[4]);
    size_t do_verify = atoi(argv[5]);
    
    printf("Allocating keys...\n");
    entry_key *keys = (entry_key *)BAllocArray(num_keys, sizeof(keys[0]));
    ASSERT_FORCE(keys);

    printf("Generating random keys...\n");
    random_bytes((char *)keys, num_keys * sizeof(keys[0]));
    
    printf("Allocating lookup indices...\n");
    uint64_t *lookup_indices = (uint64_t *)BAllocArray(num_lookups, sizeof(lookup_indices[0]));
    ASSERT_FORCE(lookup_indices);
    
    printf("Generating random lookup indices...\n");
    random_bytes((char *)lookup_indices, num_lookups * sizeof(lookup_indices[0]));
    
    printf("Allocating remove indices...\n");
    uint64_t *remove_indices = (uint64_t *)BAllocArray(num_remove, sizeof(remove_indices[0]));
    ASSERT_FORCE(remove_indices);
    
    printf("Generating random remove indices...\n");
    random_bytes((char *)remove_indices, num_remove * sizeof(remove_indices[0]));
    
    printf("Allocating entries...\n");
    ASSERT_FORCE(num_keys <= MAX_INDICES);
    struct entry *entries = (struct entry *)BAllocArray(num_keys, sizeof(*entries));
    ASSERT_FORCE(entries);
    entry_index num_used_entries = 0;
    
    MyTree tree;
    MyTree_Init(&tree);
    
    struct entry *arg = entries;
    
    ASSERT_FORCE(MyTree_IsEmpty(&tree));
#if USE_COUNTS
    ASSERT_FORCE(MyTree_Count(&tree, arg) == 0);
#endif
    
    size_t num;
#if USE_COUNTS
    size_t prevNum;
#endif
    
    printf("Inserting random numbers...\n");
    num = 0;
    for (size_t i = 0; i < num_keys; i++) {
        entries[num_used_entries].key = keys[i];
        MyTreeRef ref = {&entries[num_used_entries], num_used_entries};
        if (!MyTree_Insert(&tree, arg, ref, NULL)) {
            //printf("Insert collision!\n");
            continue;
        }
        num_used_entries++;
        num++;
    }
    printf("Inserted %" PRIsz ".\n", num);
#if USE_COUNTS
    ASSERT_FORCE(MyTree_Count(&tree, arg) == num);
#endif
    if (do_verify) {
        printf("Verifying...\n");
        MyTree_Verify(&tree, arg);
    }
    
    printf("Looking up random inserted keys...\n");
    for (size_t i = 0; i < num_lookups; i++) {
        entry_index idx = lookup_indices[i] % num_keys;
        MyTreeRef entry = MyTree_LookupExact(&tree, arg, keys[idx]);
        ASSERT_FORCE(!MyTreeIsNullRef(entry));
    }
    
#if USE_COUNTS
    prevNum = MyTree_Count(&tree, arg);
#endif
    num = 0;
    printf("Looking up and removing random inserted keys...\n");
    for (size_t i = 0; i < num_remove; i++) {
        entry_index idx = remove_indices[i] % num_keys;
        MyTreeRef entry = MyTree_LookupExact(&tree, arg, keys[idx]);
        if (MyTreeIsNullRef(entry)) {
            //printf("Remove collision!\n");
            continue;
        }
        ASSERT_FORCE(entry.ptr->key == keys[idx]);
        MyTree_Remove(&tree, arg, entry);
        num++;
    }
    printf("Removed %" PRIsz ".\n", num);
#if USE_COUNTS
    ASSERT_FORCE(MyTree_Count(&tree, arg) == prevNum - num);
#endif
    if (do_verify) {
        printf("Verifying...\n");
        MyTree_Verify(&tree, arg);
    }
    
    if (do_remove) {
#if USE_COUNTS
        prevNum = MyTree_Count(&tree, arg);
#endif
        num = 0;
        printf("Removing remaining...\n");
        
        MyTreeRef cur = MyTree_GetFirst(&tree, arg);
        while (!MyTreeIsNullRef(cur)) {
            MyTreeRef prev = cur;
            cur = MyTree_GetNext(&tree, arg, cur);
            MyTree_Remove(&tree, arg, prev);
            num++;
        }
        
        printf("Removed %" PRIsz ".\n", num);
        ASSERT_FORCE(MyTree_IsEmpty(&tree));
#if USE_COUNTS
        ASSERT_FORCE(MyTree_Count(&tree, arg) == 0);
        ASSERT_FORCE(num == prevNum);
#endif
        if (do_verify) {
            printf("Verifying...\n");
            MyTree_Verify(&tree, arg);
        }
    }
    
    printf("Freeing...\n");
    BFree(keys);
    BFree(lookup_indices);
    BFree(remove_indices);
    BFree(entries);
    
    return 0;
}
