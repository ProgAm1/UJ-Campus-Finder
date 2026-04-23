// UJ Campus Finder — Form Validation
// Team: add client-side validation functions here

/**
 * Returns true if the value is a non-empty string.
 * Usage: isRequired(input.value)
 */
function isRequired(value) {
    return value !== null && value.trim().length > 0;
}

/**
 * Returns true if the string is a valid email address.
 * Usage: isValidEmail(input.value)
 */
function isValidEmail(value) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
}

// TODO: add more validators as needed (min/max length, file type check, etc.)
