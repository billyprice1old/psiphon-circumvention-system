$(function() {
  // In case the `:target` CSS pseudo-class isn't supported, we'll also set
  // the text direction via JavaScript. (And we'll use `:target` in case JS
  // isn't supported.)
  if (window.location.hash === '#rtl') {
    $('#rtl').css({direction: 'rtl'});
  }

  // Highlight the language picker of the language we're currently on.
  var lang_file = window.location.pathname.split('/').pop();
  var lang_link = $('.lang_selector').find('a[href^="' + lang_file + '"]');
  lang_link.parent().addClass('selectedlanguage');
});
