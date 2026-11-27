<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodIndexApiTest extends TestCase
{
    use RefreshDatabase;

    private function createFood(User $user, string $name = 'Milk')
    {
        return $user->foods()->create([
            'name' => $name,
            'category' => 'Dairy',
            'quantity' => 2,
            'stored_date' => '2026-11-20',
            'use_by_date' => '2026-11-30',
            'location' => 'Fridge',
        ]);
    }

    public function test_user_can_get_food_list(): void
    {
        $user = User::factory()->create();
        $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods');

        $response->assertOk()
            ->assertJsonCount(1)
            ->assertJsonPath('0.name', 'Milk');
    }

    public function test_food_list_is_empty_when_user_has_no_foods(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods');

        $response->assertOk()
            ->assertExactJson([]);
    }

    public function test_user_only_sees_own_foods_in_list(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();

        $this->createFood($user, 'My Milk');
        $this->createFood($otherUser, 'Other Milk');

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods');

        $response->assertOk()
            ->assertJsonCount(1)
            ->assertJsonPath('0.name', 'My Milk')
            ->assertJsonMissing(['name' => 'Other Milk']);
    }

    public function test_user_can_get_multiple_own_foods(): void
    {
        $user = User::factory()->create();

        $this->createFood($user, 'Milk');
        $this->createFood($user, 'Bread');
        $this->createFood($user, 'Eggs');

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods');

        $response->assertOk()
            ->assertJsonCount(3);
    }

    public function test_food_list_contains_required_fields(): void
    {
        $user = User::factory()->create();
        $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods');

        $response->assertOk()
            ->assertJsonStructure([
                '*' => [
                    'id',
                    'user_id',
                    'name',
                    'category',
                    'quantity',
                    'stored_date',
                    'use_by_date',
                    'location',
                    'created_at',
                    'updated_at',
                ],
            ]);
    }

    public function test_guest_cannot_get_food_list(): void
    {
        $response = $this->getJson('/api/foods');

        $response->assertUnauthorized();
    }

    public function test_food_list_is_returned_as_json_array(): void
    {
        $user = User::factory()->create();
        $this->createFood($user);

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods');

        $response->assertOk();

        $this->assertIsArray($response->json());
    }

    public function test_food_list_does_not_include_other_users_food_count(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();

        $this->createFood($user, 'My Food');
        $this->createFood($otherUser, 'Other Food 1');
        $this->createFood($otherUser, 'Other Food 2');

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods');

        $response->assertOk()
            ->assertJsonCount(1);
    }
}
