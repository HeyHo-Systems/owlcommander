import {Controller} from "@hotwired/stimulus"
import {Turbo} from "@hotwired/turbo-rails";

export default class extends Controller {
    connect() {
        const href = this.element.getAttribute('data-row-href')
        const onClick = () => {
            Turbo.visit(href)
        }
        this.element.addEventListener('click', onClick)
        this.clear = () => this.element.removeEventListener('click', onClick)
    }

    disconnect() {
        this.clear()
    }
}
