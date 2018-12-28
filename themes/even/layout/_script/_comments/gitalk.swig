{% if theme.gitalk.enable %}
  <script>
     (function() {
         function render() {
             new Gitalk({
                 clientID: "{{theme.gitalk.oauth.client_id}}",
                 clientSecret: "{{theme.gitalk.oauth.client_secret}}",
                 owner: '{{theme.gitalk.github_id}}',
                 repo: '{{theme.gitalk.repo}}',
                 admin: ['tiakia'],
                 id: decodeURI(location.pathname)
             }).render('gitalk-container')
         }
         var gc = document.createElement('script');
         gc.type = 'text/javascript';
         gc.src = '//cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js';
         gc.charset = 'UTF-8';
         gc.onload = render;
         gc.async = true;
         document.querySelector('body').appendChild(gc);
         var gcs = document.createElement('link');
         gcs.href = '//cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css';
         gcs.type = 'text/css';
         gcs.rel = 'stylesheet';
         gcs.media = 'screen,print';
         document.querySelector('head').appendChild(gcs);
     })();
    </script>
{% endif %}