<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodDateValidationApiTest extends TestCase
{
    use RefreshDatabase;

    private function authenticatedUser(): User
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        return $user;
    }

    private function validFoodData(): array
    {
        return [
            'name' => 'Test Food',
            'category' => 'Vegetable',
            'quantity' => 2,
            'stored_date' => '2026-11-20',
            'use_by_date' => '2026-11-25',
            'location' => 'Refrigerator',
        ];
    }

    private function createFood(User $user): mixed
    {
        return $user->foods()->create($this->validFoodData());
    }

    public function test_store_rejects_missing_stored_date(): void
    {
        $this->authenticatedUser();

        $data = $this->validFoodData();
        unset($data['stored_date']);

        $this->postJson('/api/foods', $data)->assertUnprocessable();
    }

    public function test_store_rejects_null_stored_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['stored_date' => null]
        ))->assertUnprocessable();
    }

    public function test_store_rejects_empty_stored_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['stored_date' => '']
        ))->assertUnprocessable();
    }

    public function test_store_rejects_invalid_stored_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['stored_date' => 'not-a-date']
        ))->assertUnprocessable();
    }

    public function test_store_rejects_array_stored_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['stored_date' => ['2026-11-20']]
        ))->assertUnprocessable();
    }

    public function test_store_rejects_missing_use_by_date(): void
    {
        $this->authenticatedUser();

        $data = $this->validFoodData();
        unset($data['use_by_date']);

        $this->postJson('/api/foods', $data)->assertUnprocessable();
    }

    public function test_store_rejects_null_use_by_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['use_by_date' => null]
        ))->assertUnprocessable();
    }

    public function test_store_rejects_empty_use_by_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['use_by_date' => '']
        ))->assertUnprocessable();
    }

    public function test_store_rejects_invalid_use_by_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['use_by_date' => 'not-a-date']
        ))->assertUnprocessable();
    }

    public function test_store_rejects_array_use_by_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            ['use_by_date' => ['2026-11-25']]
        ))->assertUnprocessable();
    }

    public function test_store_rejects_use_by_date_before_stored_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            [
                'stored_date' => '2026-11-25',
                'use_by_date' => '2026-11-20',
            ]
        ))->assertUnprocessable();
    }

    public function test_store_accepts_equal_stored_and_use_by_dates(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            [
                'stored_date' => '2026-11-20',
                'use_by_date' => '2026-11-20',
            ]
        ))->assertCreated();
    }

    public function test_store_accepts_use_by_date_after_stored_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', $this->validFoodData())
            ->assertCreated();
    }

    public function test_store_accepts_valid_leap_year_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            [
                'stored_date' => '2024-02-28',
                'use_by_date' => '2024-02-29',
            ]
        ))->assertCreated();
    }

    public function test_store_rejects_invalid_leap_year_date(): void
    {
        $this->authenticatedUser();

        $this->postJson('/api/foods', array_merge(
            $this->validFoodData(),
            [
                'stored_date' => '2025-02-28',
                'use_by_date' => '2025-02-29',
            ]
        ))->assertUnprocessable();
    }

    public function test_update_rejects_invalid_stored_date(): void
    {
        $user = $this->authenticatedUser();
        $food = $this->createFood($user);

        $this->patchJson('/api/foods/' . $food->id, [
            'stored_date' => 'not-a-date',
        ])->assertUnprocessable();
    }

    public function test_update_rejects_invalid_use_by_date(): void
    {
        $user = $this->authenticatedUser();
        $food = $this->createFood($user);

        $this->patchJson('/api/foods/' . $food->id, [
            'use_by_date' => 'not-a-date',
        ])->assertUnprocessable();
    }

    public function test_update_rejects_array_stored_date(): void
    {
        $user = $this->authenticatedUser();
        $food = $this->createFood($user);

        $this->patchJson('/api/foods/' . $food->id, [
            'stored_date' => ['2026-11-20'],
        ])->assertUnprocessable();
    }

    public function test_update_rejects_array_use_by_date(): void
    {
        $user = $this->authenticatedUser();
        $food = $this->createFood($user);

        $this->patchJson('/api/foods/' . $food->id, [
            'use_by_date' => ['2026-11-25'],
        ])->assertUnprocessable();
    }

    public function test_update_rejects_use_by_date_before_existing_stored_date(): void
    {
        $user = $this->authenticatedUser();
        $food = $this->createFood($user);

        $this->patchJson('/api/foods/' . $food->id, [
            'use_by_date' => '2026-11-19',
        ])->assertUnprocessable();
    }
}
