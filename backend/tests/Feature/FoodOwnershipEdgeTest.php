<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodOwnershipEdgeTest extends TestCase
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

    public function test_user_cannot_view_another_users_food(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $this->actingAs($otherUser, 'sanctum')
            ->getJson('/api/foods/' . $food->id)
            ->assertNotFound();
    }

    public function test_user_cannot_update_another_users_food(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $this->actingAs($otherUser, 'sanctum')
            ->putJson('/api/foods/' . $food->id, [
                'name' => 'Hacked Milk',
            ])
            ->assertNotFound();

        $this->assertDatabaseHas('foods', [
            'id' => $food->id,
            'name' => 'Milk',
        ]);
    }

    public function test_user_cannot_patch_another_users_food(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $this->actingAs($otherUser, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => 'Hacked Milk',
            ])
            ->assertNotFound();

        $this->assertDatabaseHas('foods', [
            'id' => $food->id,
            'name' => 'Milk',
        ]);
    }

    public function test_user_cannot_delete_another_users_food(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $this->actingAs($otherUser, 'sanctum')
            ->deleteJson('/api/foods/' . $food->id)
            ->assertNotFound();

        $this->assertDatabaseHas('foods', [
            'id' => $food->id,
        ]);
    }

    public function test_food_owner_can_still_view_food_after_other_user_attempts_access(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $this->actingAs($otherUser, 'sanctum')
            ->getJson('/api/foods/' . $food->id)
            ->assertNotFound();

        $this->actingAs($owner, 'sanctum')
            ->getJson('/api/foods/' . $food->id)
            ->assertOk();
    }

    public function test_food_owner_can_still_update_food_after_other_user_attempts_access(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $this->actingAs($otherUser, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => 'Hacked Milk',
            ])
            ->assertNotFound();

        $this->actingAs($owner, 'sanctum')
            ->patchJson('/api/foods/' . $food->id, [
                'name' => 'Fresh Milk',
            ])
            ->assertOk()
            ->assertJsonPath('data.name', 'Fresh Milk');
    }

    public function test_food_owner_can_still_delete_food_after_other_user_attempts_access(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $this->actingAs($otherUser, 'sanctum')
            ->deleteJson('/api/foods/' . $food->id)
            ->assertNotFound();

        $this->actingAs($owner, 'sanctum')
            ->deleteJson('/api/foods/' . $food->id)
            ->assertOk();

        $this->assertDatabaseMissing('foods', [
            'id' => $food->id,
        ]);
    }

    public function test_user_cannot_access_food_owned_by_deleted_user(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $owner->delete();

        $this->actingAs($otherUser, 'sanctum')
            ->getJson('/api/foods/' . $food->id)
            ->assertNotFound();
    }

    public function test_user_cannot_modify_food_owned_by_deleted_user(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $foodId = $food->id;
        $owner->delete();

        $this->actingAs($otherUser, 'sanctum')
            ->patchJson('/api/foods/' . $foodId, [
                'name' => 'Updated Milk',
            ])
            ->assertNotFound();
    }

    public function test_user_cannot_delete_food_owned_by_deleted_user(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $food = $this->createFood($owner);

        $foodId = $food->id;
        $owner->delete();

        $this->actingAs($otherUser, 'sanctum')
            ->deleteJson('/api/foods/' . $foodId)
            ->assertNotFound();
    }
}
