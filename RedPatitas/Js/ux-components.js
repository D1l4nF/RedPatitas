/**
 * UX Components - JavaScript Utilities
 * Toast notifications, form validation, loading states, and modals
 */

// ============================================
// TOAST NOTIFICATION SYSTEM
// ============================================

class ToastNotification {
    constructor() {
        this.container = null;
        this.init();
    }

    init() {
        // Create container if doesn't exist
        if (!document.querySelector('.toast-container')) {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        } else {
            this.container = document.querySelector('.toast-container');
        }
    }

    show(options) {
        const { type = 'info', title, message, duration = 4000 } = options;

        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.innerHTML = `
            <div class="toast-icon">
                ${this.getIcon(type)}
            </div>
            <div class="toast-content">
                <div class="toast-title">${title}</div>
                <div class="toast-message">${message}</div>
            </div>
            <button class="toast-close" aria-label="Cerrar">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
            <div class="toast-progress"></div>
        `;

        this.container.appendChild(toast);

        // Trigger animation
        requestAnimationFrame(() => {
            toast.classList.add('show');
        });

        // Close button
        toast.querySelector('.toast-close').addEventListener('click', () => {
            this.hide(toast);
        });

        // Auto hide
        if (duration > 0) {
            setTimeout(() => this.hide(toast), duration);
        }

        return toast;
    }

    hide(toast) {
        toast.classList.remove('show');
        toast.classList.add('hide');
        setTimeout(() => toast.remove(), 300);
    }

    getIcon(type) {
        const icons = {
            success: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>',
            error: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>',
            warning: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 9v4M12 17h.01"></path></svg>',
            info: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="M12 16v-4M12 8h.01"></path></svg>'
        };
        return icons[type] || icons.info;
    }

    // Convenience methods
    success(title, message) { return this.show({ type: 'success', title, message }); }
    error(title, message) { return this.show({ type: 'error', title, message }); }
    warning(title, message) { return this.show({ type: 'warning', title, message }); }
    info(title, message) { return this.show({ type: 'info', title, message }); }
}

// Global toast instance
const toast = new ToastNotification();

// ============================================
// FORM VALIDATION
// ============================================

class FormValidator {
    constructor(formElement) {
        this.form = formElement;
        this.rules = {};
        this.init();
    }

    init() {
        this.form.setAttribute('novalidate', true);
        this.form.addEventListener('submit', (e) => this.handleSubmit(e));
    }

    addRule(fieldName, rules) {
        this.rules[fieldName] = rules;
        const field = this.form.querySelector(`[name="${fieldName}"]`);
        if (field) {
            field.addEventListener('blur', () => this.validateField(fieldName));
            field.addEventListener('input', () => {
                if (field.closest('.form-group').classList.contains('error')) {
                    this.validateField(fieldName);
                }
            });
        }
    }

    validateField(fieldName) {
        const field = this.form.querySelector(`[name="${fieldName}"]`);
        const rules = this.rules[fieldName];
        const formGroup = field.closest('.form-group');

        if (!rules || !field) return true;

        let isValid = true;
        let errorMessage = '';

        // Remove existing validation message
        const existingMsg = formGroup.querySelector('.validation-message');
        if (existingMsg) existingMsg.remove();

        // Check each rule
        for (const rule of rules) {
            const result = rule.validate(field.value, field);
            if (!result) {
                isValid = false;
                errorMessage = rule.message;
                break;
            }
        }

        // Update UI
        formGroup.classList.remove('error', 'success');

        if (field.value) {
            formGroup.classList.add(isValid ? 'success' : 'error');

            const msgDiv = document.createElement('div');
            msgDiv.className = `validation-message ${isValid ? 'success' : 'error'}`;
            msgDiv.innerHTML = `
                ${isValid
                    ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>'
                    : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="M12 8v4M12 16h.01"></path></svg>'
                }
                <span>${isValid ? '¡Correcto!' : errorMessage}</span>
            `;
            formGroup.appendChild(msgDiv);
        }

        return isValid;
    }

    validateAll() {
        let isValid = true;
        for (const fieldName in this.rules) {
            if (!this.validateField(fieldName)) {
                isValid = false;
            }
        }
        return isValid;
    }

    handleSubmit(e) {
        if (!this.validateAll()) {
            e.preventDefault();
            toast.error('Error', 'Por favor corrige los errores en el formulario');
        }
    }

    // Common validation rules
    static rules = {
        required: (msg = 'Este campo es requerido') => ({
            validate: (value) => value.trim().length > 0,
            message: msg
        }),
        email: (msg = 'Ingresa un correo electrónico válido') => ({
            validate: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
            message: msg
        }),
        minLength: (min, msg) => ({
            validate: (value) => value.length >= min,
            message: msg || `Debe tener al menos ${min} caracteres`
        }),
        maxLength: (max, msg) => ({
            validate: (value) => value.length <= max,
            message: msg || `No puede exceder ${max} caracteres`
        }),
        cedula: (msg = 'Ingresa una cédula válida de 10 dígitos') => ({
            validate: (value) => /^\d{10}$/.test(value),
            message: msg
        }),
        phone: (msg = 'Ingresa un número de teléfono válido') => ({
            validate: (value) => /^\d{9,10}$/.test(value.replace(/\s/g, '')),
            message: msg
        }),
        match: (fieldName, msg = 'Los campos no coinciden') => ({
            validate: (value, field) => {
                const otherField = field.form.querySelector(`[name="${fieldName}"]`);
                return otherField && value === otherField.value;
            },
            message: msg
        }),
        password: (msg = 'La contraseña debe tener al menos 8 caracteres') => ({
            validate: (value) => value.length >= 8,
            message: msg
        })
    };
}

// ============================================
// LOADING STATES
// ============================================

const Loading = {
    // Show full page loading
    show(text = 'Cargando...') {
        let overlay = document.querySelector('.loading-overlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.className = 'loading-overlay';
            overlay.innerHTML = `
                <div class="spinner large"></div>
                <div class="loading-text">${text}</div>
            `;
            document.body.appendChild(overlay);
        }
        requestAnimationFrame(() => overlay.classList.add('active'));
    },

    hide() {
        const overlay = document.querySelector('.loading-overlay');
        if (overlay) {
            overlay.classList.remove('active');
            setTimeout(() => overlay.remove(), 300);
        }
    },

    // Add loading state to button
    button(btn, loading = true) {
        if (loading) {
            btn.classList.add('loading');
            btn.disabled = true;
        } else {
            btn.classList.remove('loading');
            btn.disabled = false;
        }
    }
};

// ============================================
// CONFIRMATION MODAL
// ============================================

const Modal = {
    confirm(options) {
        return new Promise((resolve) => {
            const {
                title = '¿Estás seguro?',
                message = '',
                icon = '❓',
                confirmText = 'Confirmar',
                cancelText = 'Cancelar',
                confirmClass = 'primary',
                dangerous = false
            } = options;

            const overlay = document.createElement('div');
            overlay.className = 'modal-overlay';
            overlay.innerHTML = `
                <div class="modal">
                    <div class="modal-icon">${icon}</div>
                    <h3 class="modal-title">${title}</h3>
                    <p class="modal-message">${message}</p>
                    <div class="modal-actions">
                        <button class="modal-btn secondary" data-action="cancel">${cancelText}</button>
                        <button class="modal-btn ${dangerous ? 'danger' : confirmClass}" data-action="confirm">${confirmText}</button>
                    </div>
                </div>
            `;

            document.body.appendChild(overlay);
            requestAnimationFrame(() => overlay.classList.add('active'));

            const close = (result) => {
                overlay.classList.remove('active');
                setTimeout(() => overlay.remove(), 300);
                resolve(result);
            };

            overlay.querySelector('[data-action="confirm"]').addEventListener('click', () => close(true));
            overlay.querySelector('[data-action="cancel"]').addEventListener('click', () => close(false));
            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) close(false);
            });
        });
    },

    alert(options) {
        const { title, message, icon = 'ℹ️', buttonText = 'Entendido' } = options;

        return new Promise((resolve) => {
            const overlay = document.createElement('div');
            overlay.className = 'modal-overlay';
            overlay.innerHTML = `
                <div class="modal">
                    <div class="modal-icon">${icon}</div>
                    <h3 class="modal-title">${title}</h3>
                    <p class="modal-message">${message}</p>
                    <div class="modal-actions">
                        <button class="modal-btn primary">${buttonText}</button>
                    </div>
                </div>
            `;

            document.body.appendChild(overlay);
            requestAnimationFrame(() => overlay.classList.add('active'));

            const close = () => {
                overlay.classList.remove('active');
                setTimeout(() => overlay.remove(), 300);
                resolve();
            };

            overlay.querySelector('.modal-btn').addEventListener('click', close);
            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) close();
            });
        });
    }
};

// ============================================
// EMPTY STATES HELPER
// ============================================

const EmptyState = {
    create(options) {
        const {
            icon = '📭',
            title = 'No hay datos',
            description = '',
            actionText = '',
            actionUrl = ''
        } = options;

        const div = document.createElement('div');
        div.className = 'empty-state';
        div.innerHTML = `
            <div class="empty-state-icon">${icon}</div>
            <h3 class="empty-state-title">${title}</h3>
            <p class="empty-state-desc">${description}</p>
            ${actionText ? `<a href="${actionUrl}" class="empty-state-action">${actionText}</a>` : ''}
        `;
        return div;
    }
};

// ============================================
// EXPORT FOR MODULE USE
// ============================================
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { toast, FormValidator, Loading, Modal, EmptyState };
}
