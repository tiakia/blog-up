{% if theme.gitalk.enable %}
    <script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
    <script src='//unpkg.com/valine/dist/Valine.min.js'></script>
  <script>
     new Valine({
                 el: '#vcomments',
                 appId: 'mHpxyV0xcQyMrB2dHk2QFSLw-gzGzoHsz',
                 appKey: 'bbMgs8TWUCnI0qmOYXY0hyGA',
                 notify: false,
                 placeholder: 'ヾﾉ≧∀≦)o来啊，快活啊!',
                 avatar: 'identicon',
                 verify: false
             })
    </script>
{% endif %}