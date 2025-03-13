// Main JavaScript file for the application

document.addEventListener('DOMContentLoaded', function() {
    // Enable Bootstrap tooltips everywhere
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Add row click handler for user table
    const userTable = document.querySelector('.table');
    if (userTable) {
        const rows = userTable.querySelectorAll('tbody tr');
        rows.forEach(row => {
            row.addEventListener('click', function(e) {
                // Don't trigger if they clicked on a button or link inside the row
                if (e.target.tagName.toLowerCase() === 'a' || e.target.tagName.toLowerCase() === 'button') {
                    return;
                }
                
                // Find the "View Details" link in this row and navigate to it
                const detailsLink = this.querySelector('a.btn-outline-primary');
                if (detailsLink) {
                    window.location.href = detailsLink.href;
                }
            });
            
            // Add pointer cursor to indicate the row is clickable
            row.style.cursor = 'pointer';
        });
    }

    // Flash messages auto-hide
    const alerts = document.querySelectorAll('.alert:not(#callStatus)');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});