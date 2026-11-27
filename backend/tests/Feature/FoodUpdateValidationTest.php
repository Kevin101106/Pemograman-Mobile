<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodUpdateValidationTest extends TestCase
{
    use RefreshDatabase;

    private function createFood(User $user)
    {
        return $user->foods()->create([
            'name' => 'Milk',
            'category' => 'Dairy',
            'quantity' => 2,
            'stored_date' => '2026-11-20',
            'use_by_date' => '2026-11-30',
            'location' => 'Fridge',
        ]);
    }

    public function test_update_rejects_name_longer_than_255_characters(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => str_repeat('A', 256),
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_update_rejects_category_longer_than_255_characters(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'category' => str_repeat('A', 256),
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('category');
    }

    public function test_update_rejects_location_longer_than_255_characters(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'location' => str_repeat('A', 256),
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('location');
    }

    public function test_update_rejects_decimal_quantity(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'quantity' => 2.5,
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_update_rejects_zero_quantity(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'quantity' => 0,
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_update_rejects_null_category(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'category' => null,
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('category');
    }

    public function test_update_rejects_null_location(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'location' => null,
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('location');
    }

    public function test_update_rejects_invalid_stored_date(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'stored_date' => 'invalid-date',
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('stored_date');
    }

    public function test_update_rejects_invalid_use_by_date(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'use_by_date' => 'invalid-date',
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }

    public function test_update_rejects_use_by_date_before_new_stored_date(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'stored_date' => '2026-12-10',
                'use_by_date' => '2026-12-01',
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }
}
