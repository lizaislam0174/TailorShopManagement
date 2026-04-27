package com.tms.exception;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrityViolation(DataIntegrityViolationException ex, Model model) {
        model.addAttribute("errorTitle", "Delete Not Allowed");
        model.addAttribute("errorMessage", "This record cannot be deleted because it is linked with other data in the system.");
        model.addAttribute("errorDetails", "Please remove the related child records first, or mark this record as inactive/cancelled instead of deleting it.");
        model.addAttribute("backUrl", "javascript:history.back()");
        return "error/friendly-error";
    }

    @ExceptionHandler(RuntimeException.class)
    public String handleRuntimeException(RuntimeException ex, Model model) {
        model.addAttribute("errorTitle", "Something Went Wrong");
        model.addAttribute("errorMessage", ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred.");
        model.addAttribute("errorDetails", "Please try again. If the problem continues, contact the administrator.");
        model.addAttribute("backUrl", "javascript:history.back()");
        return "error/friendly-error";
    }

    @ExceptionHandler(Exception.class)
    public String handleGeneralException(Exception ex, Model model) {
        model.addAttribute("errorTitle", "Unexpected Error");
        model.addAttribute("errorMessage", "Something went wrong while processing your request.");
        model.addAttribute("errorDetails", "Please try again later or contact support if needed.");
        model.addAttribute("backUrl", "javascript:history.back()");
        return "error/friendly-error";
    }
}