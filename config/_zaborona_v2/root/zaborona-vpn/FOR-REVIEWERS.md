# For Reviewers

## Justifications of serving hard to read PAC-scripts

0. It's not obfuscated but compressed to fit into the 1MB limit on PAC-script size in most browsers.
1. In this repository you may find the open source codes of our pac-script generator -- we may translate it to English upon your request.
2. I understand it's difficult to evaluate if PAC-script is malicious or not. However, take into account the worst case damage it can inflict:
    - It may leak addresses user visits via dnsResolve.
    - It may return a proxy which collects addresses user visits or even modifies responses (this is explicitly allowed when user agrees to `proxy` permission in our browser extension).
3. PAC-scripts (remote or not) are executed in a kind of sandbox: they have access only to a restricted API (see https://github.com/anticensority/about-pac-scripts/blob/master/pac-script-api-chrome-55.md for details).
So they are quite benign.
