import { test, expect } from "@playwright/test";

test("home page loads", async ({ page }) => {
  await page.goto("/");
  await expect(page).toHaveTitle(/Starter App/);
  await expect(page.getByRole("heading", { name: "Starter App" })).toBeVisible();
});

test("health check displays", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByText("API Health Check")).toBeVisible();
});
