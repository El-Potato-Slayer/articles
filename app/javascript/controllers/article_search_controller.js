import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "articles"];

  connect() {
    this.inputTarget.addEventListener('input', () => this.search());
  }

  updateSearchQuery(url, query) {
    url.searchParams.set('search', query);
    window.history.pushState({ path: url.href }, '', url.href);
  }

  async getArticles(url) {
    try {
      const response = await fetch(url, {
        headers: { 'Accept': 'text/html', 'X-Requested-With': 'XMLHttpRequest' },
        method: 'GET'
      });
      const html = await response.text();
      this.articlesTarget.innerHTML = html;

    } catch (error) {
      console.error(error);
    }
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value;
      const endpoint = `/articles?search=${query}`;
      const url = new URL(window.location.origin + endpoint);

      this.updateSearchQuery(url, query)
      this.getArticles(url);
    }, 500);
  }
}
