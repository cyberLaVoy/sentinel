remove_chars_and_convert_to_real_list <- function(x) {
    # Convert character strings to real numbers
    x <- lapply(x, function(y) {
        # Remove all characters except for digits and decimals
        y <- gsub("[^0-9\\.]", "", y)

        # Convert to real number
        as.numeric(y)
    })

    # Return list of real numbers
    return(x)
}
