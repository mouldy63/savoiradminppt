<div id="NoteInner">
<hr />
<%
                                if retrieveUserRegion() = 1 then
                                %>
<form action="update-order-notes.asp" method="post" name="formNotes" onSubmit = "return validateForm2(this);">
                                    <div id = "ordernote">
                                        <input type = "hidden" name = "ordernote_id" id = "ordernote_id"
                                            value = "<%= ordernote_id %>" />
                                        <input type = "hidden" name = "order_url" id = "order_url"
                                            value = "<%= order_url %>" />
                                        <input type = "hidden" name = "order" id = "order"
                                            value = "<%= order %>" />

                                        <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                            cellspacing = "3">
                                            <tr>
                                              <td>&nbsp;</td>
                                              <td>&nbsp;</td>
                                              <td>Follow-up Date</td>
                                              <td>Status</td>
                                              <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Order Notes:
                                                </td>

                                                <td>
                                                    <textarea name = "ordernote_notetext" cols = "50" rows = "2"
                                                        class = "indentleft"></textarea>
                                                </td>
<td><input name = "ordernote_followupdate"
                                                        value = "<%= ordernote_followupdate %>" type = "text"
                                                        id = "ordernote_followupdate" size = "10" maxlength = "10">
                                              Date&nbsp;</td>

                                                <td>
                                                    <select name = "ordernote_action" id = "ordernote_action">
                                                        <option value = "<%= ACTION_REQUIRED %>"
                                                            <%= selected(ACTION_REQUIRED, ordernote_action) %>><%= ACTION_REQUIRED %></option>

                                                        <option value = "<%= NO_FURTHER_ACTION %>"
                                                            <%= selected(NO_FURTHER_ACTION, ordernote_action) %>><%= NO_FURTHER_ACTION %></option>
                                                       <option value = "<%= COMPLETED %>"
                                                            <%= selected(COMPLETED, ordernote_action) %>><%= COMPLETED %></option>
                                                    </select>
                                                </td>
                                                <td><input name="UpdateNotes" type="submit" value="Update Notes" />
                                                    
                                                </td>
                                              
                                            </tr>
                                        </table>
                                    </div>
                                    

                                            <p><a href = "javascript:showHideNotesHistory();">Show/Hide Previous Order
                                            Notes</a></p>

                                            <div id = "ordernotehistory">
                                                <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                    cellspacing = "3">
                                                    <tr>
                                                        <td>
                                                            Text
                                                        </td>

                                                        <td>
                                                            Status</td>

                                                        <td>
                                                            Created By
                                                        </td>

                                                        <td>
                                                            Created
                                                        </td>
                                                        <td> Type </td>
                                                        <td> Task Due Date</td>
                                                        <td> Completed</td>
                                                    </tr>
                                                    <%
                                                    for i = 1 to ubound(noteHistory)
                                                    %>

                                                        <tr>
                                                            <td width = "400"><%= safeHtmlEncode(noteHistory(i).text) %></td>

                                                            <td><%= noteHistory(i).action %></td>

                                                            <td><%= noteHistory(i).userName %></td>

                                                            <td><%= noteHistory(i).createdDate %></td>
                                                            <td><%= noteHistory(i).noteType %></td>
                                                            <td><%if noteHistory(i).action="Completed" then%>
                                                            <%= toDisplayDate(noteHistory(i).followUpDate) %>
                                                            <%elseif noteHistory(i).action="No Further Action" then
															else%>
                                                            <input name="Note_followupdate<%=(noteHistory(i).orderNoteId)%>" type="text" class="text" id="Note_followupdate<%=(noteHistory(i).orderNoteId)%>" value="<%= toDisplayDate(noteHistory(i).followUpDate) %>" size="10" />
                                                            <%end if%></td>
                                                            <td><%if noteHistory(i).action="Completed" then
															response.Write("Completed<br />" & left(noteHistory(i).NoteCompletedDate,10) & " " & noteHistory(i).NoteCompletedBy)
															elseif noteHistory(i).action="No Further Action" then
															else%>
															<input name="notecompleted<%=(noteHistory(i).orderNoteId)%>" id="notecompleted<%=(noteHistory(i).orderNoteId)%>" type="checkbox" />
                                                            <%end if%></td>
                                                        </tr>
                                                        <%
                                                        next
                                                        %>
                                                </table>
                                            </div>
                                    <%
                                        end if
                                    %>
                                

</form>


<hr /><br />
</div>
<script>
function validateForm2( theForm )
     {
     if (theForm.ordernote_notetext && theForm.ordernote_action && theForm.ordernote_followupdate && (theForm.ordernote_notetext.value != "" && theForm.ordernote_action.value == "To Do" && theForm.ordernote_followupdate.value == ""))
    {
	alert('Please enter a follow-up date');
	theForm.ordernote_followupdate.focus();
	return false;
	}
	if (theForm.ordernote_followupdate && theForm.ordernote_followupdate.value != "" && !isDate(theForm.ordernote_followupdate.value))
    {
        alert('Please enter a valid follow up date');
        theForm.ordernote_followupdate.focus();
        return false;
    }

    if (theForm.ordernote_followupdate && theForm.ordernote_followupdate.value != "" && theForm.ordernote_followupdate.value != ""
        && theForm.ordernote_notetext.value == "")
    {
        // Have entered a date, so lets have a note
        alert('Please enter a note for the entered follow up date');
        theForm.ordernote_notetext.focus();
        return false;
    }
	return true;
}
</script>