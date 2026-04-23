admin = User.find_or_initialize_by(email: "admin@timebank.local")
admin.name     = "Admin"
admin.role     = "admin"
admin.balance  = 0
admin.password = "admin123456" if admin.new_record?
admin.save!
