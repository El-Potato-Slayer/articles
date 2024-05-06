import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['output']

  connect() {
    this.loadResults();
  }

  async loadResults() {
    try {
      const response = await fetch('/search_analytics/results')
      const data = await response.json()
      this.displayResults(data);
    } catch (error) {
      console.error('Error fetching analytics:', error);
    }
  }

  displayResults(data) {
    if (data.status === 'ok') {
      this.outputTarget.innerHTML = '';
      this.outputTarget.classList.add('grid-cols-4')
      data.analytics.forEach((analytic) => {
        const element = document.createElement('div');
        element.innerHTML = `
          <div class="border border-gray-400 rounded-lg py-4 px-6">
            <h3 class="text-xl">
              Query: ${analytic.query}
            </h3>
            <span>
              Count:
              <span class="font-semibold">
                ${analytic.count}
              </span>
            </span>
          </div>
        `;
        this.outputTarget.appendChild(element);
      });
    } else {
      setTimeout(() => this.loadResults(), 2000)
    }
  }
}