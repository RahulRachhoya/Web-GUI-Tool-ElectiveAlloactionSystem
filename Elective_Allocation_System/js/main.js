$(document).ready(function(){
	
    $('#upbtn1').on("click",function(e){
       
		e.preventDefault();
        
		$('#UploadStreamDetails').parse({
			config: {
				delimiter: "",
                header:false,
				complete: displayHTMLTable,
			},
			before: function(file, inputElem)
			{
       				console.log("Parsing file...", file);
			},
			error: function(err, file)
			{
        			console.log("ERROR:", err, file);
			},
			complete: function()
			{
                $('#upbtn1').prop('disabled', true);
                $('#upbtn1').prop('value', 'Uploded');
					console.log("Done with all files");
			}
		});
    });

	function displayHTMLTable(results){
        
		var table = "<table class='table'>";
		var data = results.data;
		 
		for(i=1;i<data.length-1;i++){
			table+= "<tr>";
			var row = data[i];
			var cells = row.join(",").split(",");
			for(j=0;j<1;j++){
				
				table+= "<td>"+cells[j] + "</td>";

				table+="<td>" + '<input type="file" id="Streamfiles"></input>' + "</td>"
				
				table+="<td>" + '<button type="submit" id="uploadStudents" class="btn btn-primary" onclick="displayFromMain(this)">Upload File</button>' + "</td>"
				
				table+="<td>" + '<button type="submit" id="allocate" class="btn btn-primary" onclick="allocateFromMain(this)">Allocate</button>' + "</td>"
				
			}
			table+= "</tr>";
		}
		table+= "</table>";
		$("#parsed_csv_list").html(table);
	}
  });



 function displayFromMain(e){
        
    $('#Streamfiles').parse({
        config: {
            delimiter: "",
            header:false,
            //complete: StreamDetailsOperation,
        },
        before: function(file, inputElem)
        {
                   console.log("Parsing file...", file);
        },
        error: function(err, file)
        {
                console.log("ERROR:", err, file);
        },
        complete: function(results)
        {
            console.log(results.data);
            console.log("Done with all files on dynamic stream");
        }
    });

 }
// Stream details operations
function StreamDetailsOperation(result){    // Stream details operations    for all operations  inputElem   and complete operations output  elements    are defined in this function    and are passed through  to the constructor  function below  to complete operations that are defined in this function and    are passed through to the constructor function below to complete operations that are defined in this function and are passed through to the constructor function below to complete operations that are defined in this function and are passed through to the constructor function below to

    var data = result.data;
		for(var i=0; i<data.length; i++) {
			console.table(data[i]);
		}
    

}


 function allocateFromMain(e){
    alert("Allocate from main.....");
 }
  

 