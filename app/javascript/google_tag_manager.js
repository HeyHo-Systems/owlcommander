window.addEventListener("load", function () {
    window.cookieconsent.initialise({
        "palette": {
            "popup": {
                "background": "#000000"
            },
            "button": {
                "background": "#f1d600"
            }
        },
        "theme": "classic",
        "content": {
            "message": "This website uses cookies to ensure you get the best experience on our website.",
            "dismiss": "Got it!",
            "link": "Learn more",
            "href": "https://heyhosystems.com/impressum/"  // Link to your privacy policy page
        },
        "onStatusChange": function (status) {
            if (status === 'allow') {
                // If cookies are allowed, load Google Analytics, Ads, and Tag Manager scripts
                // loadGoogleAnalytics();
                // loadGoogleAds();
                // loadGoogleTagManager();
            }
        }
    });
});

(function (w, d, s, l, i) {
    w[l] = w[l] || []; w[l].push({
        'gtm.start':
            new Date().getTime(), event: 'gtm.js'
    }); var f = d.getElementsByTagName(s)[0],
        j = d.createElement(s), dl = l != 'dataLayer' ? '&l=' + l : ''; j.async = true; j.src =
            'https://www.googletagmanager.com/gtm.js?id=' + i + dl; f.parentNode.insertBefore(j, f);
})(window, document, 'script', 'dataLayer', 'GTM-KDKLVKTM');
