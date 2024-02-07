import {Controller} from "@hotwired/stimulus"

window.liveReloadPausedByUser = false

const REFRESH_INTERVAL = 5000

export default class extends Controller {
    static targets = ["form", "submit", "items", 'toggle']

    connect() {
        this.pauseRefreshBound = this.pauseRefresh.bind(this)
        this.resumeRefreshBound = this.resumeRefresh.bind(this)
        this.submitTarget.classList.add('invisible')
        if (window.liveReloadPausedByUser) {
            this.pauseRefresh()
        } else {
            this.resumeRefresh()
        }
        document.addEventListener('search:pauseRefresh', this.pauseRefreshBound)
        document.addEventListener('search:resumeRefresh', this.resumeRefreshBound)
    }

    disconnect() {
        clearTimeout(this.timeout)
        document.removeEventListener('search:pauseRefresh', this.pauseRefreshBound)
        document.removeEventListener('search:resumeRefresh', this.resumeRefreshBound)
    }

    queueRefresh(timeout) {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(this.refresh.bind(this), timeout)
    }

    toggleRefresh(e) {
        e.preventDefault()
        window.liveReloadPausedByUser = !window.liveReloadPausedByUser 

        if (window.liveReloadPausedByUser) {
            this.pauseRefresh()
        } else {
            this.resumeRefresh()
        }
    }

    pauseRefresh() {
        this.toggleTarget.innerText = 'Resume'
        clearTimeout(this.timeout)
    }

    resumeRefresh(delay = 0) { 
        if(window.liveReloadPausedByUser) return
        this.toggleTarget.innerText = 'Pause'
        this.queueRefresh(delay)
    }

    refresh() { 
        this.submitTarget.click()
        this.queueRefresh(REFRESH_INTERVAL)
    }

    search() {
        this.queueRefresh(150) 
    }


}

