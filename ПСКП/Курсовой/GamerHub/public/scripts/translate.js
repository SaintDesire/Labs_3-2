function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'ru',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
    }, 'google_translate_element');
}
googleTranslateElementInit()