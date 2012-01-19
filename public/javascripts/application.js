$.rails.allowAction = function(element) {
        var message = element.data('confirm'),
        answer = false, callback;
        if (!message) { return true; }

        if ($.rails.fire(element, 'confirm')) {
                myCustomConfirmBox(message, function() {
                        callback = $.rails.fire(element,
                                'confirm:complete', [answer]);
                        if(callback) {
                                var oldAllowAction = $.rails.allowAction;
                                $.rails.allowAction = function() { return true; };
                                element.trigger('click');
                                $.rails.allowAction = oldAllowAction;
                        }
                });
        }
        return false;
}

function myCustomConfirmBox(message, callback) {
    jConfirm(message, 'Easy Keeper Equine')
}