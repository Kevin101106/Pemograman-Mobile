<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodAuthorizationTest extends TestCase
{
    use RefreshDatabase;

    private function createFood(User $user): array
    {
        return $user->foods()->create([
            'name' => 'Milk',
            'category' => 'Dairy',
            'quantity' => 2,
            'stored_date' => '2026-11-10',
            'use_by_date' => '2026-11-15',
            'location' => 'Refrigerator',
        ])->toArray();
    }

    public function test_user_can_only_see_own_foods(): void
    {
        $userA = User::factory()->create();
        $userB = User::factory()->create();

        $foodA = $this->createFood($userA);
        $this->createFood($userB);

        $this->actingAs($userA, 'sanctum')
            ->getJson('/api/foods')
            ->assertOk()
            ->assertJsonCount(1)
            ->assertJsonFragment([
                'id' => $foodA['id'],
                'name' => 'Milk',
            ]);
    }

    public function test_user_cannot_view_another_users_food(): void
    {
        $userA = User::factory()->create();
        $userB = User::factory()->create();

        $food = $this->createFood($userA);

        $this->actingAs($userB, 'sanctum')
            ->getJson('/api/foods/' . $food['id'])
            ->assertNotFound();
    }

    public function test_user_cannot_update_another_users_food(): void
    {
        $userA = User::factory()->create();
        $userB = User::factory()->create();

        $food = $this->createFood($userA);

        $this->actingAs($userB, 'sanctum')
            ->putJson('/api/foods/' . $food['id'], [
                'name' => 'Changed Milk',
            ])
            ->assertNotFound();
    }

    public function test_user_cannot_delete_another_users_food(): void
    {
        $userA = User::factory()->create();
        $userB = User::factory()->create();

        $food = $this->createFood($userA);

        $this->actingAs($userB, 'sanctum')
            ->deleteJson('/api/foods/' . $food['id'])
            ->assertNotFound();
    }

    public function test_guest_cannot_access_food_endpoints(): void
    {
        $user = User::factory()->create();
        $food = $this->createFood($user);

        $this->getJson('/api/foods')->assertUnauthorized();

        $this->postJson('/api/foods', [])->assertUnauthorized();

        $this->getJson('/api/foods/' . $food['id'])
            ->assertUnauthorized();

        $this->putJson('/api/foods/' . $food['id'], [])
            ->assertUnauthorized();

        $this->deleteJson('/api/foods/' . $food['id'])
            ->assertUnauthorized();
    }
}
