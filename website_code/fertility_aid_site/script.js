/**
 * Fertility AId - Theme Toggle and Interactive Features
 * ====================================================
 */

/**
 * Toggle between light and dark themes
 */
function toggleTheme() {
    const html = document.documentElement;
    const themeToggle = document.querySelector('.theme-toggle');
    const themeIcon = document.querySelector('.theme-icon');
    const themeText = document.querySelector('.theme-text');
    
    const currentTheme = html.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    
    // Apply new theme
    html.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    
    // Update button text and icon
    updateThemeToggleButton(newTheme, themeIcon, themeText);
}

/**
 * Update theme toggle button appearance
 * @param {string} theme - Current theme ('light' or 'dark')
 * @param {Element} themeIcon - Theme icon element
 * @param {Element} themeText - Theme text element
 */
function updateThemeToggleButton(theme, themeIcon, themeText) {
    if (theme === 'dark') {
        themeIcon.textContent = '☀️';
        themeText.textContent = 'Light Mode';
    } else {
        themeIcon.textContent = '🌙';
        themeText.textContent = 'Dark Mode';
    }
}

/**
 * Load saved theme preference or default to light theme
 */
function loadTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    const html = document.documentElement;
    const themeIcon = document.querySelector('.theme-icon');
    const themeText = document.querySelector('.theme-text');
    
    // Apply saved theme
    html.setAttribute('data-theme', savedTheme);
    
    // Update button appearance
    updateThemeToggleButton(savedTheme, themeIcon, themeText);
}

/**
 * Setup email copy functionality
 */
function setupEmailCopy() {
    const emailElement = document.querySelector('.copyable-email');
    
    if (!emailElement) return;
    
    emailElement.addEventListener('click', function() {
        const email = this.getAttribute('data-email');
        
        // Try to copy email to clipboard
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(email).then(
                function() {
                    showCopyFeedback(emailElement);
                },
                function(err) {
                    console.error('Failed to copy email: ', err);
                    fallbackCopyText(email);
                }
            );
        } else {
            // Fallback for older browsers
            fallbackCopyText(email);
        }
    });
}

/**
 * Show visual feedback when email is copied
 * @param {Element} emailElement - Email element that was clicked
 */
function showCopyFeedback(emailElement) {
    const originalText = emailElement.textContent;
    const originalColor = emailElement.style.color;
    
    // Show "Copied!" feedback
    emailElement.textContent = 'Copied!';
    emailElement.style.opacity = '0.6';
    
    // Reset after 1 second
    setTimeout(function() {
        emailElement.textContent = originalText;
        emailElement.style.opacity = '';
        emailElement.style.color = originalColor;
    }, 1000);
}

/**
 * Fallback copy method for older browsers
 * @param {string} text - Text to copy
 */
function fallbackCopyText(text) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.left = '-999999px';
    textArea.style.top = '-999999px';
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
        document.execCommand('copy');
        const emailElement = document.querySelector('.copyable-email');
        showCopyFeedback(emailElement);
    } catch (err) {
        console.error('Fallback copy failed: ', err);
    }
    
    document.body.removeChild(textArea);
}

/**
 * Smooth scroll to top of page
 */
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

/**
 * Setup system theme detection (optional enhancement)
 */
function setupSystemThemeDetection() {
    // Check if user prefers dark mode by default
    if (!localStorage.getItem('theme')) {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        if (prefersDark) {
            localStorage.setItem('theme', 'dark');
        }
    }
    
    // Listen for system theme changes
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function(e) {
        // Only auto-switch if user hasn't manually set a preference
        if (!localStorage.getItem('theme-manually-set')) {
            const newTheme = e.matches ? 'dark' : 'light';
            localStorage.setItem('theme', newTheme);
            loadTheme();
        }
    });
}

/**
 * Mark theme as manually set when user toggles
 */
function markThemeAsManuallySet() {
    localStorage.setItem('theme-manually-set', 'true');
}

/**
 * Initialize all functionality when DOM is loaded
 */
function init() {
    // Setup system theme detection first
    setupSystemThemeDetection();
    
    // Load saved theme
    loadTheme();
    
    // Setup interactive features
    setupEmailCopy();
    
    // Add manual theme setting flag to toggle function
    const originalToggleTheme = window.toggleTheme;
    window.toggleTheme = function() {
        markThemeAsManuallySet();
        originalToggleTheme();
    };
    
    console.log('Fertility AId: Theme system initialized');
}

/**
 * Additional utility functions
 */

/**
 * Get current theme
 * @returns {string} Current theme ('light' or 'dark')
 */
function getCurrentTheme() {
    return document.documentElement.getAttribute('data-theme') || 'light';
}

/**
 * Set theme programmatically
 * @param {string} theme - Theme to set ('light' or 'dark')
 */
function setTheme(theme) {
    if (theme !== 'light' && theme !== 'dark') {
        console.error('Invalid theme. Use "light" or "dark"');
        return;
    }
    
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
    
    const themeIcon = document.querySelector('.theme-icon');
    const themeText = document.querySelector('.theme-text');
    
    if (themeIcon && themeText) {
        updateThemeToggleButton(theme, themeIcon, themeText);
    }
}

/**
 * Reset theme to system preference
 */
function resetToSystemTheme() {
    localStorage.removeItem('theme');
    localStorage.removeItem('theme-manually-set');
    setupSystemThemeDetection();
    loadTheme();
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', init);

// Export functions for potential external use
window.FertilityAIdTheme = {
    getCurrentTheme,
    setTheme,
    resetToSystemTheme,
    toggleTheme
};