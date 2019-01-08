{% if theme.valine.enable and page.valine %}
    <script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
    <script src='//unpkg.com/valine/dist/Valine.min.js'></script>
  <script>
     new Valine({
                 el: '#vcomments',
                 appId: '{{theme.valine.appId}}',
                 appKey: '{{theme.valine.appKey}}',
                 placeholder: '{{theme.valine.placeholder}}',
                 avatar: '{{theme.valine.avatar}}',
                 notify: '{{theme.valine.notify}}',
                 verify: '{{theme.valine.verify}}'
             })
    </script>
{% endif %}