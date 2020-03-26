## NOTES

* When an upload error occurs, the user is presented with a simple generic error message.
* When upload is successful, the user is presented with a simple success message, and can review the processed records.
* Assuming an uploaded file can contain valid headers but no actual data, the user is informed when this happens.

* Assuming that the reporting system might have no public internet connection, I have included "Twitter Bootstrap" for basic styling, as opposed to loading it off an external CDN.
* Assuming that the user has little technical knowledge, I've attempted to keep any informational messages simple.
* Assuming newest orders first, the orders are sorted by date and number descending.
* Since the data is highly hierarchical in nature, I've placed it in a simple schema (see orders.db.sql) with an index tuned to sorting order listed above.
* Since ther is no guarantee that order data is not split across multiple uploads, the system accepts all uploaded data as being correct. 
    * This means that multiple uploads of the same file will result in duplicate items.
    * This is also concerned when dealing with order quantity (say, an order of 2 fountain pens).
* Since multiple manufacturers can have items with the same name, the item manufacturer is included in the report for clarity.
* Since a customer can be exist multiple times with a identical normalized name, but with a different customer number, the customer number is included in the report for clarity.
* Assuming that item price is always in USD, the value is stored (with currency symbol removed) as floating-point and formatted accordingly in the report view. 
* Since it is not known what other data may occur in orders apart from the sample data, basic sanitation is done by Text::CSV_XS. Other than that, surrounding whitespace is trimmed for each data column.

## FURTHER CONSIDERATIONS

* Since the Twitter Bootstrap CSS is not in-line, when saving a report as .html, it is not included. Depending if the user wants to e-mail the report, including this CSS in-line might be preferred when viewing the report. This could be achieved by using a conditional [% INCLUDE %] in the wrapper layout.
* Given the data ambiguity listed under notes, I'd preferrably discuss these with the client when she returns, so that possible incorrect data entry can be prevented. If ordered item data can be considered unique, this can easily be changed by enforcing a multi-column key constraint (orderNumber, customerNumber, itemId) on the orders schema.

