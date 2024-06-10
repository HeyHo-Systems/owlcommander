let timeout = null

// Click to copy interraction
function clearCopiedClass() {
    document.querySelector('*[data-click-to-copy].copied')?.classList.remove('copied')
    clearTimeout(timeout)
}

document.addEventListener('scroll', clearCopiedClass)
document.addEventListener('click', (e) => {
    clearCopiedClass()
    if (e.target.hasAttribute('data-click-to-copy')) {
        e.preventDefault();
        e.stopPropagation()
        try {
            navigator.clipboard.writeText(e.target.textContent)
            e.target.classList.add('copied')
            timeout = setTimeout(clearCopiedClass, 1000)
        } catch (e) {
            alert(`Your browser doesn't seem to support copy events : ${e.message}`)
        }
    }
}, true)

