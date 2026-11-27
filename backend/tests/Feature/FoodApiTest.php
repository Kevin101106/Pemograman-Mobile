<?php

namespace Tests\Feature;

use App\Models\Food;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodApiTest extends TestCase
{
    use RefreshDatabase;

    private function createFood(User $user): Food
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

    public function test_user_can_add_food_successfully(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertCreated()
            ->assertJsonPath('data.name', 'Milk');

        $this->assertDatabaseHas('foods', [
            'name' => 'Milk',
            'user_id' => $user->id,
        ]);
    }

    public function test_store_requires_food_name(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'category' => 'Dairy',
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_store_requires_category(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('category');
    }

    public function test_store_requires_quantity(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_store_requires_stored_date(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 2,
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('stored_date');
    }

    public function test_store_requires_use_by_date(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }

    public function test_store_requires_location(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('location');
    }

    public function test_store_rejects_zero_quantity(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 0,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_store_rejects_decimal_quantity(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 2.5,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_store_rejects_use_by_date_before_stored_date(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 2,
                'stored_date' => '2026-11-30',
                'use_by_date' => '2026-11-20',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }

    public function test_store_rejects_name_longer_than_255_characters(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => str_repeat('A', 256),
                'category' => 'Dairy',
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_store_rejects_category_longer_than_255_characters(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => str_repeat('A', 256),
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => 'Fridge',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('category');
    }

    public function test_store_rejects_location_longer_than_255_characters(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Milk',
                'category' => 'Dairy',
                'quantity' => 2,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-30',
                'location' => str_repeat('A', 256),
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('location');
    }

    public function test_user_can_view_own_food(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods/' . $food->id);

        $response->assertOk()
            ->assertJsonPath('name', 'Milk');
    }

    public function test_user_can_update_food_successfully(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->putJson('/api/foods/' . $food->id, [
                'name' => 'Chocolate Milk',
                'category' => 'Dairy',
                'quantity' => 5,
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-12-01',
                'location' => 'Fridge',
            ]);

        $response->assertOk()
            ->assertJsonPath('data.name', 'Chocolate Milk')
            ->assertJsonPath('data.quantity', 5);

        $this->assertDatabaseHas('foods', [
            'id' => $food->id,
            'name' => 'Chocolate Milk',
            'quantity' => 5,
        ]);
    }

    public function test_user_can_update_only_food_name(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => 'Fresh Milk',
            ]);

        $response->assertOk()
            ->assertJsonPath('data.name', 'Fresh Milk')
            ->assertJsonPath('data.category', 'Dairy');
    }

    public function test_update_rejects_zero_quantity(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'quantity' => 0,
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('quantity');
    }

    public function test_update_rejects_use_by_date_before_stored_date(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'use_by_date' => '2026-11-19',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('use_by_date');
    }

    public function test_update_rejects_null_food_name(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => null,
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors('name');
    }

    public function test_user_can_delete_own_food(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->deleteJson('/api/foods/' . $food->id);

        $response->assertOk()
            ->assertJson(['message' => 'Makanan berhasil dihapus']);

        $this->assertDatabaseMissing('foods', [
            'id' => $food->id,
        ]);
    }

    public function test_food_is_deleted_when_owner_is_deleted(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $user->delete();

        $this->assertDatabaseMissing('foods', [
            'id' => $food->id,
        ]);
    }

    public function test_store_accepts_same_stored_and_use_by_date(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/foods', [
                'name' => 'Fresh Bread',
                'category' => 'Bakery',
                'quantity' => 1,
                'stored_date' => '2026-11-27',
                'use_by_date' => '2026-11-27',
                'location' => 'Fridge',
            ]);

        $response->assertCreated()
            ->assertJsonPath('data.name', 'Fresh Bread');
    }
}
