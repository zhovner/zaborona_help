function FindProxyForURL(url, host) {
	var domains = [
		'2ch.hk', 'apivk.com', 'auto.ru', 'donationalerts.ru', 'drweb.com', 'drweb.ru', 'imgsmail.ru', 'kaspersky.ru', 'kaspersky.ua', 'kinopoisk.ru', 'livejournal.ru', 'mail.ru', 'mradx.net', 'mycdn.me', 'odnoklassniki.com.ua', 'odnoklassniki.ru', 'odnoklassniki.ua', 'ok.com', 'ok.me', 'ok.ru', 'userapi.com', 'vk-cdn.me', 'vk-cdn.net', 'vk.cc', 'vk.com', 'vk.me', 'vkontakte.ru', 'ya.ru', 'yadi.sk', 'yandex.com', 'yandex.fr', 'yandex.net', 'yandex.ru', 'yandex.st', 'yandex.ua', 'yandexdatafactory.com', 'yastatic.net'
	];

	var proxify = domains.findIndex(function(domain) {
		return dnsDomainIs(host, domain) || shExpMatch(host, '*.' + domain);
	}) >= 0;

	if (proxify)
		return 'HTTPS proxy.antizapret.prostovpn.org:3143; PROXY proxy.antizapret.prostovpn.org:3128; DIRECT';

	return 'DIRECT';
}