const bcrypt = require('bcrypt');
const mongoose = require('mongoose');

const SALT_ROUNDS = 10; // You can adjust the number of salt rounds as needed

const UserSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },

  name: { type: String },
  address: { type: String },
  country: { type: String }, // Add country field
  dateOfBirth: { type: Date },
  nationality: { type: String },
  resume: { type: String },
  resumeType: { type: String },
  mobile1: { type: String },
  mobile2: { type: String },
  age: { type: Number },
  gender: { type: String },
  linkedin: { type: String },  // Common LinkedIn field for both Candidate and Employer
  image: { type: String },
  role: { type: String, required: true, enum: ['candidate', 'employer', 'admin', 'super-admin'] },
  walletPoints: { type: Number, default: 0 },
  myrefcode: {
    type: String,
    unique: true, // Ensure that myrefcode is unique
  },

  // DND feature fields
  dnd: {
    isActive: { type: Boolean, default: false }, // Whether DND is enabled
    startDate: { type: Date },                   // When DND was enabled
    endDate: { type: Date },                     // When DND will expire
  },

  // Candidate-specific fields
  currentJobTitle: { type: String }, // Only for candidates
  experienceLevel: { type: String }, // Only for candidates
  availability: { type: String },    // Only for candidates
  maritalStatus: { type: String },   // Only for candidates

  // Employer-specific fields
  companyName: { type: String },           // Only for employers
  companyWebsite: { type: String },        // Only for employers
  companyAddress: { type: String },        // Only for employers
  companyIndexNo: { type: String },        // Only for employers
  companyEstablishmentYear: { type: Number }, // Only for employers
  companyContactPerson: {
    name: { type: String },
    designation: { type: String },
    contactNumber: { type: String },
    officialEmail: { type: String },
    personalEmail: { type: String },
    country: { type: String },
    mobileNumber: { type: String },
    callTimings: { type: String },
  },

  // Social media links
  facebook: { type: String },
  twitter: { type: String },
  googlePlus: { type: String },

  category: { type: String },
  city: { type: String }, // New field for city
  zipCode: { type: String }, // New field for zip code
  about: { type: String },
  
  // OTP and Verification fields
  otp: {
    type: String,
    default: '',
  },
  otpExpiration: Date,
  verified: { type: Boolean, default: false },

  // User activation status
  active: {
    type: Boolean,
    default: true
  },
  registeredTimeStamp: { type: Date, default: Date.now }, // Add registeredtimestamp field
  jobPostIds: [{ type: mongoose.Schema.Types.ObjectId}]
});

// Hash the password before saving
UserSchema.pre('save', function (next) {
  if (this.isModified('password')) {
    bcrypt.hash(this.password, SALT_ROUNDS, (err, hash) => {
      if (err) {
        return next(err);
      }
      this.password = hash; // Store the hash
      next();
    });
  } else {
    next();
  }
});

module.exports = mongoose.model('User', UserSchema);