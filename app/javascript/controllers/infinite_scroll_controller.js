import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["scrollArea", "pagination", "items"]

    connect() {
        this.createObserver()
        this.paginationTarget.style.visibility = "hidden"
    }


    createObserver() {
        this.observer = new IntersectionObserver(
            entries => this.handleIntersect(entries),
            {
                // https://github.com/w3c/IntersectionObserver/issues/124#issuecomment-476026505
                threshold: [0, 1.0],
            }
        )
        this.observer.observe(this.scrollAreaTarget)
    }

    disconnect() {
        this.observer.unobserve(this.scrollAreaTarget)
    }

    handleIntersect(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                this.loadMore()
            }
        })
    }

    loadMore() {
        const next = this.paginationTarget.querySelector("[rel=next]")
        if (!next) {
            this.scrollAreaTarget.innerHTML = '<div class="w-full pt-4 text-sm text-center italic text-gray-600">The end!</div>'
            return
        }

        document.dispatchEvent(new Event('search:pauseRefresh'))
        const href = next.href
        fetch(href, {
            headers: {
                Accept: "text/vnd.turbo-stream.html",
            },
        })
            .then(r => r.text())
            .then(html => Turbo.renderStreamMessage(html))
    }
}
