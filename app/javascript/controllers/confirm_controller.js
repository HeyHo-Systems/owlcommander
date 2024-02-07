import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        message: {type: String, default: 'Are you sure ?'},
    }


    confirm(e) {
        if (!confirm(this.messageValue)) {
            e.preventDefault()
            e.stopPropagation()
        }
    }

    connect() {
        this.boundConfirm = this.confirm.bind(this)
        this.element.addEventListener('submit', this.boundConfirm)

    }

    disconnect() {
        this.element.removeEventListener('submit', this.boundConfirm)
    }
}
