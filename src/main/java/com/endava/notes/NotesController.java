package com.endava.notes;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;

@RestController
public class NotesController {

    private final static ArrayList<String> notes = new ArrayList<>();

    static {
        notes.add("Note 1");
        notes.add("Note 2");
    }

    @GetMapping("/")
    public String welcome() {
        return "Welcome to Notes";
    }

    @GetMapping("/notes")
    public String getNotes() {
        return notes.toString();
    }

    @GetMapping("/notes/{note}")
    public String addNote(@PathVariable String note) {
        notes.add(note);
        return notes.toString();
    }
}
