function deleteEntry(index) {
    if (confirm("Вы уверены, что хотите удалить эту запись?")) {
        fetch(`/delete/${index}`, { method: 'POST' })
            .then(() => {
                window.location.href = '/';
            })
            .catch(err => console.error(err));
    }
}

document.querySelectorAll('input[name=name]').forEach(input => {
    input.addEventListener('input', function() {
        const deleteButton = this.parentElement.querySelector('button[type=button]');
        if (this.value.length > 0) {
            deleteButton.removeAttribute('disabled');
        } else {
            deleteButton.setAttribute('disabled', true);
        }
    });
});
