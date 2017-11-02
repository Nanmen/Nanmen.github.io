{% if theme.busuanzi_count.enable %}

<div class="busuanzi-count">

{% if theme.busuanzicount.enable %}
  <div class="copyright">
    {% if theme.busuanzicount.siteuv %}
      <span class="powered-by">
      {{ theme.busuanzicount.siteuvheader }}
        <span class="busuanzi-value" id="busuanzivaluesiteuv"></span>
        {{ theme.busuanzicount.siteuvfooter }}
      </span>
    {% endif %}
    {% if theme.busuanzicount.sitepv %}
      <span class="theme-info">
      {{ theme.busuanzicount.sitepvheader }}
        <span class="busuanzi-value" id="busuanzivaluesitepv"></span>
      {{ theme.busuanzicount.sitepvfooter }}
      </span>
    {% endif %}
  </div>
{% endif %}
