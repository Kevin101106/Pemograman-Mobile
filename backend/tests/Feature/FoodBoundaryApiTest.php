<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodBoundaryApiTest extends TestCase
{
    use RefreshDatabase;

    private function foodData(): array
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

    private function createFood(User $user)
    {
        return $user->foods()->create($this->foodData());
    }

    public function test_store_accepts_quantity_of_one(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'quantity' => 1,
            ]))
            ->assertCreated()
            ->assertJsonPath('data.quantity', 1);
    }

    public function test_store_accepts_name_with_255_characters(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'name' => str_repeat('A', 255),
            ]))
            ->assertCreated();
    }

    public function test_store_accepts_category_with_255_characters(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'category' => str_repeat('A', 255),
            ]))
            ->assertCreated();
    }

    public function test_store_accepts_location_with_255_characters(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'location' => str_repeat('A', 255),
            ]))
            ->assertCreated();
    }

    public function test_store_rejects_boolean_quantity(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'quantity' => true,
            ]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_store_rejects_array_quantity(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'quantity' => [1, 2],
            ]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_store_rejects_array_name(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'name' => ['Milk'],
            ]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_store_rejects_array_category(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'category' => ['Dairy'],
            ]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('category');
    }

    public function test_store_rejects_array_location(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'location' => ['Fridge'],
            ]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('location');
    }

    public function test_store_rejects_array_stored_date(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'stored_date' => ['2026-11-20'],
            ]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('stored_date');
    }

    public function test_store_rejects_array_use_by_date(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', array_merge($this->foodData(), [
                'use_by_date' => ['2026-11-30'],
            ]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }

    public function test_update_accepts_quantity_of_one(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'quantity' => 1,
            ])
            ->assertOk()
            ->assertJsonPath('data.quantity', 1);
    }

    public function test_update_accepts_name_with_255_characters(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => str_repeat('A', 255),
            ])
            ->assertOk();
    }

    public function test_update_accepts_category_with_255_characters(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'category' => str_repeat('A', 255),
            ])
            ->assertOk();
    }

    public function test_update_accepts_location_with_255_characters(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'location' => str_repeat('A', 255),
            ])
            ->assertOk();
    }

    public function test_update_rejects_null_quantity(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'quantity' => null,
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_update_rejects_empty_name(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => '',
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_update_rejects_empty_category(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'category' => '',
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('category');
    }

    public function test_update_rejects_empty_location(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'location' => '',
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('location');
    }

    public function test_update_rejects_stored_date_after_existing_use_by_date(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'stored_date' => '2026-12-01',
            ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }
}
