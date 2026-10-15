/* SalesPulse Page 1 dashboard. Requires SP_DASHBOARD_JSON application Ajax Callback. */
(function () {
  'use strict';
  function start() {
    const root = document.getElementById('spDashboard');
    if (!root) return;
    const $ = id => document.getElementById(id);
    const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
    const money = n => 'LKR ' + Number(n || 0).toLocaleString('en-US', {maximumFractionDigits:0});
    function render(data) {
      const kpis = [
        ['Paid revenue', money(data.sales), '◈', '#6255ed', '#f0edff'],
        ['Paid orders', Number(data.orders || 0).toLocaleString(), '▣', '#f18c31', '#fff1df'],
        ['Units sold', Number(data.units || 0).toLocaleString(), '◉', '#9455d9', '#f5eaff'],
        ['Customers', Number(data.customers || 0).toLocaleString(), '♙', '#dc4eae', '#fff0fa']
      ];
      $('spKpis').innerHTML = kpis.map(k => `<article class="sp-kpi" style="--sp-accent:${k[3]};--sp-soft:${k[4]}"><div class="sp-kpi-head"><span class="sp-kpi-icon">${k[2]}</span>${k[0]}</div><div class="sp-kpi-number">${k[1]}</div><div class="sp-kpi-foot">Live Oracle Database values</div></article>`).join('');
      const categories = Array.isArray(data.categories) ? data.categories : [];
      const maxCat = Math.max(1,...categories.map(c=>Number(c.value)||0));
      $('spCategories').innerHTML = categories.length ? categories.map(c=>`<div class="sp-cat-row"><span class="sp-cat-name" title="${escapeHtml(c.label)}">${escapeHtml(c.label)}</span><div class="sp-cat-track"><div class="sp-cat-fill" style="width:${Math.max(0,100*(Number(c.value)||0)/maxCat)}%"></div></div><span class="sp-cat-amount">${money(c.value)}</span></div>`).join('') : '<p>No category sales yet.</p>';
      const recent = Array.isArray(data.recent) ? data.recent : [];
      $('spRecent').innerHTML = recent.length ? recent.map(o=>`<tr><td>#${escapeHtml(o.id)}</td><td>${escapeHtml(o.customer)}</td><td>${escapeHtml(o.date)}</td><td><span class="sp-status sp-status--${['PAID','PENDING','CANCELLED','REFUNDED'].includes(o.status)?o.status.toLowerCase():'pending'}">${escapeHtml(o.status)}</span></td><td>${money(o.total)}</td></tr>`).join('') : '<tr><td colspan="5">No orders available</td></tr>';
      const trend = Array.isArray(data.trend) ? data.trend : [];
      const svg = $('spTrend');
      if (!trend.length) { svg.replaceChildren(); $('spTrendAxis').textContent='No revenue trend available'; return; }
      const w=620,h=230,px=18,py=24,max=Math.max(1,...trend.map(x=>Number(x.value)||0))*1.15;
      const points=trend.map((x,i)=>[px+(w-2*px)*i/Math.max(1,trend.length-1),h-py-(h-2*py)*(Number(x.value)||0)/max]);
      const path=points.map((p,i)=>(i?'L':'M')+p[0].toFixed(1)+','+p[1].toFixed(1)).join(' ');
      const fill=path+` L${points[points.length-1][0]},${h-py} L${points[0][0]},${h-py} Z`;
      svg.innerHTML=`<defs><linearGradient id="spGradient" x1="0" x2="0" y1="0" y2="1"><stop offset="0" stop-color="#7663ed" stop-opacity=".28"/><stop offset="1" stop-color="#7663ed" stop-opacity="0"/></linearGradient></defs>${[0,1,2,3].map(i=>`<line x1="18" x2="602" y1="${24+i*58}" y2="${24+i*58}" stroke="#edf0f7" stroke-dasharray="4 6"/>`).join('')}<path d="${fill}" fill="url(#spGradient)"/><path d="${path}" fill="none" stroke="#6757ee" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>${points.map(p=>`<circle cx="${p[0]}" cy="${p[1]}" r="3" fill="#fff" stroke="#6757ee" stroke-width="2"/>`).join('')}`;
      $('spTrendAxis').innerHTML=`<span>${escapeHtml(trend[0].label)}</span><span>${escapeHtml(trend[trend.length-1].label)}</span>`;
    }
    function load() {
      $('spUpdated').textContent='Loading…';
      if (!window.apex || !apex.server) { $('spUpdated').textContent='Open inside Oracle APEX to load live data'; return; }
      apex.server.process('SP_DASHBOARD_JSON', {}, {
        dataType:'json',
        success: function(data){render(data);$('spUpdated').textContent='Updated '+new Date().toLocaleTimeString();},
        error: function(xhr){console.error('SP_DASHBOARD_JSON error',xhr);$('spUpdated').textContent='Data unavailable — check Ajax Callback and browser console';}
      });
    }
    $('spRefresh').addEventListener('click',load);
    load();
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded',start); else start();
})();
