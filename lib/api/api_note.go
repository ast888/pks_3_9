package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

// Note представляет заметку
type Note struct {
	ID          string `json:"id"`
	PhotoID     string `json:"photo_id"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Price       string `json:"price"`
	RAM         string `json:"ram"`
	SimCards    string `json:"simCards"`
	Supports5G  string `json:"supports5G"`
	ScreenSize  string `json:"screenSize"`
	RefreshRate string `json:"refreshRate"`
	Camera      string `json:"camera"`
	Processor   string `json:"processor"`
	IsLiked     bool   `json:"isLiked"`
	Quantity    int    `json:"quantity"`
}

// Пример списка заметок
var notes = []Note{
	{
		ID:          "1",
		PhotoID:     "https://20.img.avito.st/image/1/1.fUYIfra50a8-1xOqfn9HH5Td16W8Xdltud3Tq7TX260.jwZjCU1WCYtFOFDLQ-h4YwHpmVh96V7nLAfadaT25C4",
		Title:       "iPhone 6S",
		Description: "REF, состояние хорошее",
		Price:       "7000",
		RAM:         "16GB",
		SimCards:    "1",
		Supports5G:  "No",
		ScreenSize:  "4.7 inches",
		RefreshRate: "60Hz",
		Camera:      "12MP",
		Processor:   "A9",
		IsLiked:     false,
		Quantity:    1,
	},
	{
		ID:          "2",
		PhotoID:     "https://avatars.mds.yandex.net/get-goods_pic/11762621/hat5bb7bdd1b6c022e6b2c29b1807a3263e/600x600",
		Title:       "iPhone 7",
		Description: "Состояние отличное, 32GB",
		Price:       "10000",
		RAM:         "2GB",
		SimCards:    "1",
		Supports5G:  "No",
		ScreenSize:  "4.7 inches",
		RefreshRate: "60Hz",
		Camera:      "12MP",
		Processor:   "A10 Fusion",
		IsLiked:     false,
		Quantity:    1,
	},
	{
		ID:          "3",
		PhotoID:     "https://avatars.mds.yandex.net/get-goods_pic/10767871/hat8bfc4bf589c5e1f8e2be4a0fe8ca21cc/600x600",
		Title:       "iPhone 8",
		Description: "Состояние хорошее, 64GB",
		Price:       "15000",
		RAM:         "2GB",
		SimCards:    "1",
		Supports5G:  "No",
		ScreenSize:  "4.7 inches",
		RefreshRate: "60Hz",
		Camera:      "12MP",
		Processor:   "A11 Bionic",
		IsLiked:     false,
		Quantity:    1,
	},
	{
		ID:          "4",
		PhotoID:     "https://avatars.mds.yandex.net/get-goods_pic/11770674/hat8b1705bee106eda2278f2e006e432ec9/600x600",
		Title:       "iPhone X",
		Description: "Состояние отличное, 64GB",
		Price:       "25000",
		RAM:         "3GB",
		SimCards:    "1",
		Supports5G:  "No",
		ScreenSize:  "5.8 inches",
		RefreshRate: "60Hz",
		Camera:      "12MP + 12MP",
		Processor:   "A11 Bionic",
		IsLiked:     false,
		Quantity:    1,
	},
	{
		ID:          "5",
		PhotoID:     "https://avatars.mds.yandex.net/get-goods_pic/8375998/hatb3d719b534b8657ed9663a1ad0ab5a89/600x600",
		Title:       "iPhone 11",
		Description: "Состояние новое, 128GB",
		Price:       "40000",
		RAM:         "4GB",
		SimCards:    "2",
		Supports5G:  "No",
		ScreenSize:  "6.1 inches",
		RefreshRate: "60Hz",
		Camera:      "12MP + 12MP",
		Processor:   "A13 Bionic",
		IsLiked:     false,
		Quantity:    1,
	},
	{
		ID:          "6",
		PhotoID:     "https://avatars.mds.yandex.net/get-goods_pic/9098895/hatc5ffce770db11e56aaa6a7d884719610/600x600",
		Title:       "iPhone 12",
		Description: "Состояние отличное, 64GB",
		Price:       "60000",
		RAM:         "4GB",
		SimCards:    "2",
		Supports5G:  "Yes",
		ScreenSize:  "6.1 inches",
		RefreshRate: "60Hz",
		Camera:      "12MP + 12MP",
		Processor:   "A14 Bionic",
		IsLiked:     false,
		Quantity:    1,
	},
}

// Пример списка избранных заметок
var favoriteNotes = []Note{}

// обработчик для GET-запроса, возвращает список заметок
func getNotesHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(notes)
}

// обработчик для POST-запроса, добавляет заметку
func createNoteHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var newNote Note
	err := json.NewDecoder(r.Body).Decode(&newNote)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	notes = append(notes, newNote)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(newNote)
}

// Получение заметки по ID
func getNoteByIDHandler(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Path[len("/notes/"):]
	for _, note := range notes {
		if note.ID == idStr {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(note)
			return
		}
	}
	http.Error(w, "Note not found", http.StatusNotFound)
}

// Удаление заметки по ID
func deleteNoteHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := r.URL.Path[len("/notes/delete/"):]
	for i, note := range notes {
		if note.ID == idStr {
			notes = append(notes[:i], notes[i+1:]...)
			w.WriteHeader(http.StatusNoContent)
			return
		}
	}
	http.Error(w, "Note not found", http.StatusNotFound)
}

// Обновление заметки по ID
// Обновление заметки по ID
func updateNoteHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := r.URL.Path[len("/notes/update/"):]
	var updatedData Note
	err := json.NewDecoder(r.Body).Decode(&updatedData)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	for i, note := range notes {
		if note.ID == idStr {
			// Обновляем только изменённые поля
			if updatedData.Title != "" {
				notes[i].Title = updatedData.Title
			}
			if updatedData.Description != "" {
				notes[i].Description = updatedData.Description
			}
			if updatedData.PhotoID != "" {
				notes[i].PhotoID = updatedData.PhotoID
			}

			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(notes[i])
			return
		}
	}
	http.Error(w, "Note not found", http.StatusNotFound)
}

// обработчик для получения избранных заметок
func getFavoriteNotesHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	if len(favoriteNotes) == 0 {
		// Если избранных заметок нет, возвращаем пустой список
		json.NewEncoder(w).Encode([]Note{})
		return
	}
	json.NewEncoder(w).Encode(favoriteNotes)
}

// обработчик для добавления заметки в избранное
func addToFavoritesHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var note Note
	err := json.NewDecoder(r.Body).Decode(&note)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	favoriteNotes = append(favoriteNotes, note)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(note)
}

// обработчик для удаления заметки из избранного
func removeFromFavoritesHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := r.URL.Path[len("/favorites/"):]
	for i, note := range favoriteNotes {
		if note.ID == idStr {
			favoriteNotes = append(favoriteNotes[:i], favoriteNotes[i+1:]...)
			w.WriteHeader(http.StatusNoContent)
			return
		}
	}
	http.Error(w, "Note not found", http.StatusNotFound)
}

func main() {
	http.HandleFunc("/notes", getNotesHandler)           // Получить все заметки
	http.HandleFunc("/notes/create", createNoteHandler)  // Создать заметку
	http.HandleFunc("/notes/", getNoteByIDHandler)       // Получить заметку по ID
	http.HandleFunc("/notes/update/", updateNoteHandler) // Обновить заметку
	http.HandleFunc("/notes/delete/", deleteNoteHandler) // Удалить заметку

	// Новые маршруты для избранных заметок
	http.HandleFunc("/favorites", getFavoriteNotesHandler)     // Получить избранные заметки
	http.HandleFunc("/favorites/add", addToFavoritesHandler)   // Добавить заметку в избранное
	http.HandleFunc("/favorites/", removeFromFavoritesHandler) // Удалить заметку из избранного

	fmt.Println("Server is running on port 8080!")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}
