var dragObject = new function () {
	var me = this;

	var eventNoticeNode, dragEventNoticeNode;

	// var dataTransferCommentString;

	me.init = function () {

		if (EventHelpers.hasPageLoadHappened(arguments)) {
			return;
		}

        for (var i = 0; i < document.all.length; i++)
        {
            if (document.all[i].id.indexOf("dropTarget") != -1)
            {
                var targetNode = document.getElementById(document.all[i].id);
                EventHelpers.addEvent(targetNode, 'dragover', dragOverEvent);
                EventHelpers.addEvent(targetNode, 'drop', dropEvent);
            }
        }

		eventNoticeNode = document.getElementById('eventNotice');
		dragEventNoticeNode = document.getElementById('dragEventNotice');

		/* These are events for the draggable objects */
		var dragNodes = cssQuery('[draggable=true]');
		for (var i = 0; i < dragNodes.length; i++) {
			var  dragNode=dragNodes[i];
			EventHelpers.addEvent(dragNode, 'dragstart', dragStartEvent);
		}
	}

    function dragStartEvent(e) {
        e.dataTransfer.effectAllowed = "copy";
		e.dataTransfer.setData('Text', this.innerHTML);
	}

	function dragOverEvent(e) {
        e.dataTransfer.effectAllowed = "copy";
		EventHelpers.preventDefault(e);
	}

	function dropEvent(e) {
        var customer_text = this.innerHTML;
        var customer_split = customer_text.split("----");
        if (customer_split.length == 2)
        {
            var customer_id = customer_split[1];
            var customer_split_2 = customer_id.split("<");
            customer_id = customer_split_2[0];

            var item_text = e.dataTransfer.getData('Text');
            var item_split = item_text.split("----");
            if (item_split.length == 2)
            {
                var item_id = item_split[1];
                var item_split_2 = item_id.split("<");
                item_id = item_split_2[0];
                window.location.href = "items/new?customer=" + customer_id + "&category=" + item_id;
                //alert("items/new?customer=" + customer_id + "&category=" + item_id);
                //alert("CustomerID = " + customer_id + ", ItemID = " + item_id);
            }
        }
		EventHelpers.preventDefault(e);
	}
}

// fixes visual cues in IE and Chrome 3.0 and lower.
DragDropHelpers.fixVisualCues=true;

EventHelpers.addPageLoadEvent('dragObject.init');