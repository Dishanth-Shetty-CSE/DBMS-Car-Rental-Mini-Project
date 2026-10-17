/**
 * Global Confirmation Alert Utility (SweetAlert2)
 * Triggered on button actions across Admin and Customer portals
 */
function confirmAction(options, callback) {
    if (typeof options === 'string') {
        options = { title: options };
    }
    options = options || {};

    const title = options.title || "Are you sure?";
    const text = options.text || "Please confirm that you want to proceed.";
    const icon = options.icon || "question";
    const confirmButtonText = options.confirmButtonText || options.confirmText || "Yes, proceed";
    const cancelButtonText = options.cancelButtonText || options.cancelText || "Cancel";
    const confirmButtonColor = options.confirmButtonColor || "#2563eb";
    const actionCallback = typeof callback === 'function' ? callback : (typeof options.onConfirm === 'function' ? options.onConfirm : null);

    return Swal.fire({
        title: title,
        text: text,
        icon: icon,
        showCancelButton: true,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: "#64748b",
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            if (typeof actionCallback === 'function') {
                actionCallback();
            }
        }
    });
}
