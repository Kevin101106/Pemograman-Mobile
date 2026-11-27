<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodNotFoundApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_cannot_view_nonexistent_food(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods/99999')
            ->assertNotFound();
    }

    public function test_user_cannot_update_nonexistent_food(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->putJson('/api/foods/99999', ['name' => 'Updated'])
            ->assertNotFound();
    }

    public function test_user_cannot_patch_nonexistent_food(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->patchJson('/api/foods/99999', ['name' => 'Updated'])
            ->assertNotFound();
    }

    public function test_user_cannot_delete_nonexistent_food(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->deleteJson('/api/foods/99999')
            ->assertNotFound();
    }

    public function test_guest_cannot_view_nonexistent_food(): void
    {
        $this->getJson('/api/foods/99999')
            ->assertUnauthorized();
    }

    public function test_guest_cannot_update_nonexistent_food(): void
    {
        $this->putJson('/api/foods/99999', ['name' => 'Updated'])
            ->assertUnauthorized();
    }

    public function test_guest_cannot_patch_nonexistent_food(): void
    {
        $this->patchJson('/api/foods/99999', ['name' => 'Updated'])
            ->assertUnauthorized();
    }

    public function test_guest_cannot_delete_nonexistent_food(): void
    {
        $this->deleteJson('/api/foods/99999')
            ->assertUnauthorized();
    }

    public function test_user_cannot_view_food_with_invalid_id(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->getJson('/api/foods/invalid')
            ->assertNotFound();
    }

    public function test_user_cannot_delete_food_with_invalid_id(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->deleteJson('/api/foods/invalid')
            ->assertNotFound();
    }
}
