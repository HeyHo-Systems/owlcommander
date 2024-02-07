import {Controller} from "@hotwired/stimulus"
import {Turbo} from "@hotwired/turbo-rails";

export default class extends Controller {
    connect() {
        const onKeyUp = (e) => {
            if (e.key === 'ArrowUp' || e.key === 'ArrowDown') {
                // find all clickable rows
                const urls = [...document.querySelectorAll('div[data-row-href]')].map(node => node.getAttribute('data-row-href'))
                const currentRow = document.querySelector('div[data-row-href][data-selected="true"]')
                const currentPath = currentRow?.getAttribute('data-row-href')
                const index = urls.indexOf(currentPath)
                if (index !== -1) {
                    const delta = e.key === 'ArrowUp' ? -1 : 1
                    const newUrl = urls[index + delta]
                    if (newUrl) {
                        Turbo.visit(newUrl)
                        currentRow.removeAttribute('data-selected')
                        e.preventDefault()
                    }
                } else {
                    console.log('current url not in list', urls, currentPath)
                }
            }
        }
        document.documentElement.addEventListener('keyup', onKeyUp)
        this.clear = () => document.documentElement.removeEventListener('keyup', onKeyUp)
    }

    disconnect() {
        this.clear()
    }
}
