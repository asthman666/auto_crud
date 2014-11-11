function modal_show_msg($modal, $code) {
    if ( $code == 1 ) {
        $modal.modal('show').find('.modal-body').prepend('<div class="alert alert-info fade in">Success!<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
        setTimeout(function(){$modal.modal('hide')}, 600);
    } else {
        $modal.modal('show').find('.modal-body').prepend('<div class="alert alert-error fade in">Error!<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
    }
}

function operateFormatter(value, row, index) {
    return [
        '<a class="update ml10" href="javascript:void(0)" title="Update">',
        '<i class="icon-edit"></i>',
        '</a>',
        '<a class="remove ml10" style="padding-left:15px;" href="javascript:void(0)" data-toggle="modal" title="Remove">',
        '<i class="icon-remove"></i>',
        '</a>',
    ].join('');
}
