{# Post Copyright #}
{% if theme.copyright.enable and page.copyright !== false %}
  <div class="post-copyright">
    <p class="copyright-item">
      <span>文章标题: </span>
      <a href="{{ page.permalink }}">{{page.title}}</a>
    </p>
    <p class="copyright-item">
      <span>{{ __('copyright.author') + ': ' }}</span>
      <a href="{{ config.url }}">{{ config.author }}</a>
    </p>
    <p class="copyright-item">
      <span>发表时间: </span>
      <span>
        {{ full_date(page.date, 'YYYY-MM-DD, HH:MM:mm') }}
      </span>
    </p>
    <p class="copyright-item">
      <span>最后更新: </span>
      <span>
        {{ full_date(page.updated, 'YYYY-MM-DD, HH:MM:mm') }}
      </span>
    </p>

    <p class="copyright-item">
      <span>{{ __('copyright.link') + ': ' }}</span>
      <a href="{{ page.permalink }}">{{ page.permalink }}</a>
    </p>
    <p class="copyright-item">
      <span>{{ __('copyright.license') + ': ' }}</span>
      {% set license = page.license || theme.copyright.license %}
      {{ license }}
    </p>
  </div>
