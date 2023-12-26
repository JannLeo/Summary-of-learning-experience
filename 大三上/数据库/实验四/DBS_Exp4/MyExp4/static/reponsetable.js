(function(e) {
	e.fn.reponsetable = function(obj) {
		var tableid = $(this).attr("id");
		reponse.rendertable(obj, tableid);
		var tr=$(this).find("tr");
		$("tr").click(function(e) {
			 var dd = reponse.resiverowdata(this, tableid);
		})
	}
	var reponse = {
		//加载表格
		rendertable: function(tableobj, tableid) {
			var thead = "<thead><tr>";
			var tbody = "<tbody>";
			for (var i = 0; i < tableobj.colum.length; i++) {
				var th = '<th data-field="' + tableobj.colum[i].field + '">' + tableobj.colum[i].title + '</th>';
				thead += th;
			}
			if (tableobj.operation !== "" || tableobj != null) {
				thead += '<th data-field="' + tableobj.operation + '">操作</th>'
			}
			thead += '</tr></thead>';
			for (var i = 0; i < tableobj.data.length; i++) {
				tbody += '<tr>'
				// if (tableobj.type !== "" || tableobj != null) {
				// 	// var editor = $("#" + tableobj.operation).html();
				// 	// tbody += '<td data-th="操作">' + editor + '</td>';
				// 	var sort=i+1;
				// 	var td='<td>'+ sort +'</td>';
				// }
				for (var j = 0; j < tableobj.colum.length; j++) {
					var field = tableobj.colum[j].field;
					var datath = tableobj.colum[j].title;
					var content = tableobj.data[i][field];
					if (content == undefined) content = "";
					var td = '<td data-field="' + field + '" data-th="' + datath + '">' + content + '</td>';
					tbody += td;
				}
				if (tableobj.operation !== "" || tableobj != null) {
					var editor = $("#" + tableobj.operation).html();
					tbody += '<td data-th="操作">' + editor + '</td>';
				}
				tbody += '</tr>'
			}
			tbody += "</tbody>"
			$("#" + tableid).prepend(thead);
			$("#" + tableid).append(tbody);
			//存table对象
			var tbodytr=$("#"+tableid).find("tbody tr");
			var data=[];
			for(var i=0;i<tbodytr.length;i++){
				var tbodytd=$(tbodytr[i]).find("td");
				var colobj={};
				for(var j=0;j<tbodytd.length;j++){
					var field=$(tbodytd[j]).attr("data-field");
					var text=$(tbodytd[j]).text();
					if(field!=undefined){
					 colobj[field]=text;
					}
				}
				data.push(colobj);
			}
			tableobj.data=data;
			$("#" + tableid).data('tableObj', tableobj);
		},
		//删除一行
		deletetr: function(row, e) {
			$(row).remove();
			if (e && e.stopPropagation) {
				e.stopPropagation();
			} else {
				window.event.cancelBubble = true;
			}
		},
		//新增一行
		addtr: function(obj, tableid) {
			var tableobj = $("#" + tableid).data("tableObj");
			var tr = "<tr>";
			for (var i = 0; i < tableobj.colum.length; i++) {
				var field = tableobj.colum[i].field;
				var datath = tableobj.colum[i].title;
				var content = obj[field];
				if (content == undefined) content = "";
				var td = '<td data-field="' + field + '" data-th="' + datath + '">' + content + '</td>'
				tr += td;
			}
		
			if (tableobj.operation !== "" || tableobj != null) {
				var editor = $("#" + tableobj.operation).html();
				tr += '<td data-th="操作">' + editor + '</td>';
			}
			tr += '</tr>';
			$("#" + tableid + " tbody").append(tr);
		},
		//获取单机行编辑行的数据
		resiverowdata: function(row, tableid, e) {
			var idno=$(row).parent().is("thead");
			if(!idno){
				$(row).addClass("yesbei").siblings().removeClass("yesbei");}
			var td = $(row).find("td");
			var data = {};
			for (var i = 0; i < td.length; i++) {
				field = $(td[i]).attr("data-field");
				content = $(td[i]).text();
				if(field!=undefined){
				 data[field] = content;
				}
				// data[field] = content;
			};
			var row = $("#" + tableid).data("row", row);
			var rowdata = $("#" + tableid).data("rowdata", data);
			return data;
			if (e && e.stopPropagation) {
				e.stopPropagation();
			} else {
				window.event.cancelBubble = true;
			}
		},
		//保存编辑的行
		editsavetr: function(obj, tableid, e) { //row为当前行,obj是增加的对象	
			var row = $("#" + tableid).data("row");
			if(row==undefined){
				alert("请选中要编辑的行");
				return;
			}
			var td = $(row).find("td");
			for (var i = 0; i < td.length; i++) {
				var keys = $(td[i]).attr("data-field");
				var hideclass = $(td[i]).hasClass('bt-hide');
				if (obj[keys] != undefined || obj[keys] != null) {
					$(td[i]).text(obj[keys]);
				}
			}
			if (e && e.stopPropagation) {
				e.stopPropagation();
			} else {
				window.event.cancelBubble = true;
			}
		},
		//上移
		moveuptr: function(row, tableid, e) {
			if (row != null) {
				var current = row;
			} else {
				current = $("#" + tableid).data("row");
			}
			if (current == undefined) {
				alert("请选择要移动的行");
			} else {
				var prev = $(current).prev(); //获取当前<tr>前一个元素
				if ($(current).index() > 0) {
					$(current).insertBefore(prev); //插入到当前<tr>前一个元素前
				} else {
					alert("已经移到最顶部");
				}
			}
			if (e && e.stopPropagation) {
				e.stopPropagation();
			} else {
				window.event.cancelBubble = true;
			}
		},
		//下移
		moveDown: function(row, tableid, e) {	
			if (row != null) {
				var current = row;
			} else {
				current = $("#" + tableid).data("row");
			}
			if (current == undefined) {
				alert("请选择要移动的行");
			} else {
				var next = $(current).next();
				if (next.index() > 0) {
					$(current).insertAfter(next); 
				} else {
					alert("已经移到最底部");
				}
			}
			if (e && e.stopPropagation) {
				e.stopPropagation();
			} else {
				window.event.cancelBubble = true;
			}
		},
		//导出ExportExcel
		JSONToCSVConvertor: function(JSONData, ShowLabel,titlename) {
			var arrData = typeof JSONData !== 'object' ? JSON.parse(JSONData) : JSONData;
			var xls = '';
			if (ShowLabel) {
				var row = "";
				for (var i=0;i<arrData.colum.length;i++){
					row+=arrData.colum[i].title+',';
				}
				row = row.slice(0, -1);
				xls += row + '\r\n';
			}
			for (var i = 0; i < arrData.data.length; i++) {
				var row = "";
				for (var index in arrData.data[i]) {
					var arrValue = arrData.data[i][index] == null ? "" : '="' + arrData.data[i][index] + '"';
					row += arrValue + ',';
				}
				row.slice(0, row.length - 1);
				xls += row + '\r\n';
			}
			if (xls == '') {
				growl.error("Invalid data");
				return;
			}
		// var fileName = "aaa";
			if (this.msieversion()) {
				var IEwindow = window.open();
				IEwindow.document.write('sep=,\r\n' + xls);
				IEwindow.document.close();
				IEwindow.document.execCommand('SaveAs', true, titlename + ".xls");
				IEwindow.close();
			} else {
				var uri = 'data:text/xls;charset=utf-8,\uFEFF' + encodeURI(xls);
				var link = document.createElement("a");
				link.href = uri;
				link.style = "visibility:hidden";
				link.download = titlename + ".xls";
				document.body.appendChild(link);
				link.click();
				document.body.removeChild(link);
			}
		},
		msieversion: function() {
			var ua = window.navigator.userAgent;
			var msie = ua.indexOf("MSIE ");
			if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) 
			{
				return true;
			} else { // If another browser,
				return false;
			}
			return false;
		},
		// //刷新table数据
		reloadtable:function(data,tableid){
			var tableObj=$("#"+tableid).data("tableObj");
			tableObj.data=data;
			$("#"+tableid).html("");
			this.rendertable(tableObj,tableid);
		},

		//获取某一列的数据
		Columndata:function(col, tableid){
			var coldata=[];
			var colnu=$("#"+tableid).find('td[data-field='+col+']');
			for(var i=0;i<colnu.length;i++){
				var data=$(colnu[i]).text();
				coldata.push(data);
			}
			return coldata;
		}

	}
	window.reponse = reponse;
}(jQuery));
