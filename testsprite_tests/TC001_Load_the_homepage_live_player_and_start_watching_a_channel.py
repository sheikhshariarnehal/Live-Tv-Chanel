import asyncio
import re
from playwright import async_api
from playwright.async_api import expect

async def run_test():
    pw = None
    browser = None
    context = None

    try:
        # Start a Playwright session in asynchronous mode
        pw = await async_api.async_playwright().start()

        # Launch a Chromium browser in headless mode with custom arguments
        browser = await pw.chromium.launch(
            headless=True,
            args=[
                "--window-size=1280,720",
                "--disable-dev-shm-usage",
                "--ipc=host",
                "--single-process"
            ],
        )

        # Create a new browser context (like an incognito window)
        context = await browser.new_context()
        # Wider default timeout to match the agent's DOM-stability budget;
        # auto-waiting Playwright APIs (expect, locator.wait_for) inherit this.
        context.set_default_timeout(15000)

        # Open a new page in the browser context
        page = await context.new_page()

        # Interact with the page elements to simulate user flow
        # -> navigate
        await page.goto("http://localhost:3000")
        try:
            await page.wait_for_load_state("domcontentloaded", timeout=5000)
        except Exception:
            pass
        
        # -> Open the homepage (http://localhost:3000/) and wait for the live player and channel list to load so the page shows the player area and channel tiles.
        await page.goto("http://localhost:3000/")
        try:
            await page.wait_for_load_state("domcontentloaded", timeout=5000)
        except Exception:
            pass
        
        # -> Open the homepage (http://localhost:3000/) and wait for the live player area and the channel list/grid to finish loading so the player and tiles are visible.
        await page.goto("http://localhost:3000/")
        try:
            await page.wait_for_load_state("domcontentloaded", timeout=5000)
        except Exception:
            pass
        
        # -> Click the 'Retry' button shown on the player overlay to attempt to reload the stream and then observe whether playback begins or an error persists.
        # Retry button
        elem = page.locator('[id="btnReloadStream"]')
        await elem.click(timeout=10000)
        
        # -> Click the 'World Cup 2026' channel tile in the channel list to force the player to load that stream and observe whether playback starts and the active channel state appears.
        # World Cup 2026 button
        elem = page.get_by_role('button', name='World Cup 2026', exact=True)
        await elem.click(timeout=10000)
        
        # -> Click the 'World Cup 2026' channel tile in the channel list to attempt to load its stream and then observe whether the player begins playback or an error persists.
        # World Cup 2026 button
        elem = page.get_by_role('button', name='World Cup 2026', exact=True)
        await elem.click(timeout=10000)
        
        # -> Click the 'BeINSports-1' channel tile to attempt playback and observe whether the player starts and the active channel state appears.
        # BeINSports-1 button
        elem = page.get_by_role('button', name='BeINSports-1', exact=True)
        await elem.click(timeout=10000)
        
        # -> Click the 'BeINSports-1' channel tile to attempt to start playback and observe whether the player begins playing and the active channel state appears.
        # BeINSports-1 button
        elem = page.get_by_role('button', name='BeINSports-1', exact=True)
        await elem.click(timeout=10000)
        
        # --> Assertions to verify final state
        
        # --> Verify the selected stream is playing
        await page.locator("xpath=/html/body/div/div/div[1]/div/div[1]/div/video").nth(0).scroll_into_view_if_needed()
        # Assert: Expected the video player element to be visible.
        await expect(page.locator("xpath=/html/body/div/div/div[1]/div/div[1]/div/video").nth(0)).to_be_visible(timeout=15000), "Expected the video player element to be visible."
        # Assert: Expected the player error 'Retry' button to not be visible.
        await expect(page.locator("xpath=/html/body/div/div/div[1]/div/div[2]/div/div[4]/button").nth(0)).not_to_be_visible(timeout=15000), "Expected the player error 'Retry' button to not be visible."
        
        # --> Verify the active channel state is shown
        # Assert: Expected the BeINSports-1 channel tile to be marked active (aria-pressed=true).
        await expect(page.locator("xpath=/html/body/div/div/div[2]/div[2]/div[1]/button[2]").nth(0)).to_have_attribute("aria-pressed", "true", timeout=15000), "Expected the BeINSports-1 channel tile to be marked active (aria-pressed=true)."
        # Assert: Expected the player container to indicate the active channel via data-active-channel='BeINSports-1'.
        await expect(page.locator("xpath=/html/body/div/div/div[1]/div/div[1]/div").nth(0)).to_have_attribute("data-active-channel", "BeINSports-1", timeout=15000), "Expected the player container to indicate the active channel via data-active-channel='BeINSports-1'."
        # Assert: Expected the player area to display the active channel name 'BeINSports-1'.
        await expect(page.locator("xpath=/html/body/div/div/div[1]/div/div[1]/div").nth(0)).to_contain_text("BeINSports-1", timeout=15000), "Expected the player area to display the active channel name 'BeINSports-1'."
        await asyncio.sleep(5)

    finally:
        if context:
            await context.close()
        if browser:
            await browser.close()
        if pw:
            await pw.stop()

asyncio.run(run_test())
    