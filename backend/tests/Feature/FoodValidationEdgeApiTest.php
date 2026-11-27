<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodValidationEdgeApiTest extends TestCase
{
    use RefreshDatabase;

    private function validFoodData(): array
    {
        return [
            'name' => 'Milk',
            'category' => 'Dairy',
            'quantity' => 2,
            'stored_date' => '2026-11-20',
            'use_by_date' => '2026-11-30',
            'location' => 'Fridge',
        ];
    }

    public function test_store_rejects_negative_quantity(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge(
                $this->validFoodData(),
                ['quantity' => -1]
            ));

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_store_rejects_text_quantity(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge(
                $this->validFoodData(),
                ['quantity' => 'two']
            ));

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_store_rejects_invalid_stored_date(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge(
                $this->validFoodData(),
                ['stored_date' => 'not-a-date']
            ));

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('stored_date');
    }

    public function test_store_rejects_invalid_use_by_date(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge(
                $this->validFoodData(),
                ['use_by_date' => 'not-a-date']
            ));

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }

    public function test_store_rejects_empty_food_name(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge(
                $this->validFoodData(),
                ['name' => '']
            ));

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_store_rejects_empty_category(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge(
                $this->validFoodData(),
                ['category' => '']
            ));

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('category');
    }

    public function test_store_rejects_empty_location(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge(
                $this->validFoodData(),
                ['location' => '']
            ));

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('location');
    }

    public function test_update_rejects_negative_quantity(): void
    {
        $user = User::factory()->create();

        $food = $user->foods()->create($this->validFoodData());

        $response = $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'quantity' => -5,
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_update_rejects_invalid_stored_date(): void
    {
        $user = User::factory()->create();

        $food = $user->foods()->create($this->validFoodData());

        $response = $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'stored_date' => 'not-a-date',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('stored_date');
    }

    public function test_update_rejects_invalid_use_by_date(): void
    {
        $user = User::factory()->create();

        $food = $user->foods()->create($this->validFoodData());

        $response = $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'use_by_date' => 'not-a-date',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }
}
