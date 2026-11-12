<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Food;
use Illuminate\Http\Request;

class FoodController extends Controller
{
    public function index(Request $request)
    {
        return response()->json(
            $request->user()->foods()->latest()->get()
        );
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'category' => 'required|string|max:255',
            'quantity' => 'required|integer|min:1',
            'stored_date' => 'required|date',
            'use_by_date' => 'required|date|after_or_equal:stored_date',
            'location' => 'required|string|max:255',
        ]);

        $food = $request->user()->foods()->create($validated);

        return response()->json([
            'message' => 'Makanan berhasil ditambahkan',
            'data' => $food,
        ], 201);
    }

    public function show(Request $request, Food $food)
    {
        $food = $request->user()->foods()->findOrFail($food->id);

        return response()->json($food);
    }

    public function update(Request $request, Food $food)
    {
        $food = $request->user()->foods()->findOrFail($food->id);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'category' => 'sometimes|required|string|max:255',
            'quantity' => 'sometimes|required|integer|min:1',
            'stored_date' => 'sometimes|required|date',
            'use_by_date' => 'sometimes|required|date|after_or_equal:stored_date',
            'location' => 'sometimes|required|string|max:255',
        ]);

        $food->update($validated);

        return response()->json([
            'message' => 'Makanan berhasil diperbarui',
            'data' => $food,
        ]);
    }

    public function destroy(Request $request, Food $food)
    {
        $food = $request->user()->foods()->findOrFail($food->id);

        $food->delete();

        return response()->json([
            'message' => 'Makanan berhasil dihapus',
        ]);
    }
}
