"use client";

import * as React from "react";
import {
  Button,
  Card,
  CardActions,
  CardContent,
  CardHeader,
  Divider,
  FormControl,
  Grid,
  InputLabel,
  OutlinedInput,
  Select,
  MenuItem,
  TextField,
  Box,
  Typography,
  IconButton,
  Snackbar,
  Alert,
} from "@mui/material";
import { Add, Delete, Upload } from "@mui/icons-material";
import axios from "axios";
import apikey from "@/constants/apikey";
import MuiAlert from "@mui/material/Alert";
import type { AlertColor } from "@mui/material/Alert";
import RidesList from "./RidesList";

const includesOptions = ["Helmet", "Instructor", "Water", "Insurance"];
const specificationOptions = {
  ageLimit: ["6+", "12+", "18+"],
  difficulty: ["Easy", "Medium", "Hard"],
  language: ["English", "Sinhala", "Tamil"],
};

interface RideImage {
  file: File;
  previewUrl: string;
}

interface RideSpecifications {
  ageLimit: string;
  difficulty: string;
  language: string;
  [key: string]: string;
}

interface RideForm {
  title: string;
  description: string;
  location: string;
  duration: string;
  distance: string;
  price: string;
  rating: string;
  reviews: string;
  images: RideImage[];
  includes: string[];
  maxParticipants: string;
  specifications: RideSpecifications;
  expect: string;
  route: { start: string; end: string };
  additionalInfo: string[];
  cancelPolicy: string;
  contact: string;
  [key: string]: any;
}

export default function RidesPage() {
  const [form, setForm] = React.useState<RideForm>({
    title: "",
    description: "",
    location: "",
    duration: "",
    distance: "",
    price: "",
    rating: "",
    reviews: "",
    images: [],
    includes: [],
    maxParticipants: "",
    specifications: { ageLimit: "", difficulty: "", language: "" },
    expect: "",
    route: { start: "", end: "" },
    additionalInfo: [""],
    cancelPolicy: "",
    contact: "",
  });

  const [loading, setLoading] = React.useState(false);
  const [success, setSuccess] = React.useState(false);
  const [error, setError] = React.useState("");
  const [snackbar, setSnackbar] = React.useState<{ open: boolean; message: string; severity: AlertColor }>({ open: false, message: "", severity: "success" });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSpecChange = (e: React.ChangeEvent<{ name?: string; value: unknown }>) => {
    const { name, value } = e.target as { name: string; value: string };
    setForm((prev) => ({
      ...prev,
      specifications: { ...prev.specifications, [name]: value },
    }));
  };

  const handleIncludesChange = (event: any) => {
    const value = event.target.value;
    setForm((prev) => ({
      ...prev,
      includes: Array.isArray(value) ? value : typeof value === "string" ? value.split(",") : [],
    }));
  };

  const handleAdditionalInfoChange = (idx: number, value: string) => {
    setForm((prev) => {
      const additionalInfo = [...prev.additionalInfo];
      additionalInfo[idx] = value;
      return { ...prev, additionalInfo };
    });
  };

  const addAdditionalInfoField = () => {
    setForm((prev) => ({
      ...prev,
      additionalInfo: [...prev.additionalInfo, ""],
    }));
  };

  const removeAdditionalInfoField = (idx: number) => {
    setForm((prev) => {
      const additionalInfo = [...prev.additionalInfo];
      additionalInfo.splice(idx, 1);
      return { ...prev, additionalInfo };
    });
  };

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    const newImages: RideImage[] = files.map((file) => ({
      file,
      previewUrl: URL.createObjectURL(file),
    }));
    setForm((prev) => ({
      ...prev,
      images: [...prev.images, ...newImages],
    }));
  };

  const removeImage = (index: number) => {
    setForm((prev) => {
      const images = [...prev.images];
      images.splice(index, 1);
      return { ...prev, images };
    });
  };

  const baseUrl = apikey.baseUrl;

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setSuccess(false);
    setError("");
    try {
      // Prepare rideData (exclude images)
      const {
        images, // eslint-disable-line @typescript-eslint/no-unused-vars
        ...rideData
      } = form;
      // Prepare FormData
      const formData = new FormData();
      formData.append("rideData", JSON.stringify(rideData));
      
      form.images.forEach((img, idx) => {
        formData.append("ridesImage", img.file);
      });
      
      const res = await axios.post(`${baseUrl}/api/rides`, formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      setSuccess(true);
      setSnackbar({ open: true, message: "Ride created successfully!", severity: "success" });
      setForm({
        title: "",
        description: "",
        location: "",
        duration: "",
        distance: "",
        price: "",
        rating: "",
        reviews: "",
        images: [],
        includes: [],
        maxParticipants: "",
        specifications: { ageLimit: "", difficulty: "", language: "" },
        expect: "",
        route: { start: "", end: "" },
        additionalInfo: [""],
        cancelPolicy: "",
        contact: "",
      });
    } catch (err: any) {
      setError(err?.response?.data?.error || err.message || "Unknown error");
      setSnackbar({ open: true, message: err?.response?.data?.error || err.message || "Unknown error", severity: "error" });
    } finally {
      setLoading(false);
    }
  };

  const handleSnackbarClose = (_event?: React.SyntheticEvent | Event, reason?: string) => {
    if (reason === "clickaway") return;
    setSnackbar((prev) => ({ ...prev, open: false }));
  };

  return (
    <>
      <form onSubmit={handleSubmit}>
        <Card>
          <CardHeader
            title="Add New Ride"
            subheader="Enter the ride details below"
          />
          <Divider />
          <CardContent>
            <Snackbar open={snackbar.open} autoHideDuration={4000} onClose={handleSnackbarClose} anchorOrigin={{ vertical: 'top', horizontal: 'center' }}>
              <Alert elevation={6} variant="filled" onClose={handleSnackbarClose} severity={snackbar.severity} sx={{ width: '100%' }}>
                {snackbar.message}
              </Alert>
            </Snackbar>
            <Grid container spacing={3}>
              <Grid item xs={12} md={6}>
                <TextField
                  label="Title"
                  name="title"
                  value={form.title}
                  onChange={handleChange}
                  fullWidth
                  required
                />
              </Grid>
              <Grid item xs={12} md={6}>
                <TextField
                  label="Location"
                  name="location"
                  value={form.location}
                  onChange={handleChange}
                  fullWidth
                  required
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  label="Description"
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  fullWidth
                  multiline
                  minRows={2}
                />
              </Grid>

              {/* Specs */}
              {[
                { label: "Duration", name: "duration" },
                { label: "Distance (KM)", name: "distance" },
                { label: "Price ($)", name: "price", type: "number" },
                { label: "Rating", name: "rating", type: "number" },
                { label: "Reviews", name: "reviews", type: "number" },
                { label: "Max Participants", name: "maxParticipants", type: "number" },
              ].map((item, i) => (
                <Grid item xs={12} md={4} key={i}>
                  <TextField
                    label={item.label}
                    name={item.name}
                    value={form[item.name] as string}
                    onChange={handleChange}
                    fullWidth
                    type={item.type || "text"}
                  />
                </Grid>
              ))}

              <Grid item xs={12}>
                <FormControl fullWidth sx={{ width: "200px"}}>
                  <InputLabel>Includes</InputLabel>
                  <Select
                    fullWidth
                    multiple
                    name="includes"
                    value={form.includes}
                    onChange={handleIncludesChange}
                    input={<OutlinedInput label="Includes" />}
                    renderValue={(selected) => selected.join(", ")}
                  >
                    {includesOptions.map((inc) => (
                      <MenuItem key={inc} value={inc}>
                        {inc}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>

              <Grid container spacing={3}>
                {Object.entries(specificationOptions).map(([key, options]) => (
                  <Grid item xs={12} sm={12} md={12} key={key} sx={{ width: "200px" }}>
                    <FormControl fullWidth variant="outlined">
                      <InputLabel id={`${key}-label`}>
                        {key.split(/(?=[A-Z])/).join(' ')}
                      </InputLabel>
                      <Select
                        labelId={`${key}-label`}
                        name={key}
                        value={form.specifications[key]}
                        onChange={(e) => handleSpecChange(e as React.ChangeEvent<{ name?: string; value: unknown }>)}
                        label={key.split(/(?=[A-Z])/).join(' ')}
                      >
                        <MenuItem value="">
                          <em>Select {key.toLowerCase()}</em>
                        </MenuItem>
                        {options.map((option) => (
                          <MenuItem key={option} value={option}>
                            {option}
                          </MenuItem>
                        ))}
                      </Select>
                    </FormControl>
                  </Grid>
                ))}
              </Grid>

              <Grid item xs={12}>
                <TextField
                  label="What to Expect"
                  name="expect"
                  value={form.expect}
                  onChange={handleChange}
                  fullWidth
                  multiline
                  minRows={2}
                />
              </Grid>

              <Grid item xs={12} md={6}>
                <TextField
                  label="Route Start"
                  name="routeStart"
                  value={form.route.start}
                  onChange={(e) =>
                    setForm((prev) => ({
                      ...prev,
                      route: { ...prev.route, start: e.target.value },
                    }))
                  }
                  fullWidth
                />
              </Grid>
              <Grid item xs={12} md={6}>
                <TextField
                  label="Route End"
                  name="routeEnd"
                  value={form.route.end}
                  onChange={(e) =>
                    setForm((prev) => ({
                      ...prev,
                      route: { ...prev.route, end: e.target.value },
                    }))
                  }
                  fullWidth
                />
              </Grid>

              <Grid item xs={12}>
                <TextField
                  label="Cancelation Policy"
                  name="cancelPolicy"
                  value={form.cancelPolicy}
                  onChange={handleChange}
                  fullWidth
                  multiline
                  minRows={2}
                />
              </Grid>

              <Grid item xs={12} md={6}>
                <TextField
                  label="Contact Info"
                  name="contact"
                  value={form.contact}
                  onChange={handleChange}
                  fullWidth
                />
              </Grid>

              {/* Image Upload */}
              <Grid item xs={12}>
                <Typography variant="subtitle1" gutterBottom>
                  Upload Ride Images
                </Typography>
                <Button
                  variant="outlined"
                  component="label"
                  startIcon={<Upload />}
                >
                  Upload Images
                  <input
                    type="file"
                    hidden
                    accept="image/*"
                    multiple
                    onChange={handleImageUpload}
                  />
                </Button>
                <Box mt={2} display="flex" gap={2} flexWrap="wrap">
                  {form.images.map((img, idx) => (
                    <Box key={idx} position="relative">
                      <img
                        src={img.previewUrl}
                        alt={`upload-${idx}`}
                        style={{ width: 120, height: 80, borderRadius: 8, objectFit: "cover" }}
                      />
                      <IconButton
                        size="small"
                        onClick={() => removeImage(idx)}
                        style={{
                          position: "absolute",
                          top: -10,
                          right: -10,
                          background: "white",
                        }}
                      >
                        <Delete fontSize="small" />
                      </IconButton>
                    </Box>
                  ))}
                </Box>
              </Grid>

              {/* Additional Info */}
              <Grid item xs={12}>
                <Typography variant="subtitle1" gutterBottom>
                  Additional Information
                </Typography>
                {form.additionalInfo.map((info, idx) => (
                  <Box key={idx} display="flex" alignItems="center" gap={1} mb={1}>
                    <TextField
                      label={`Info #${idx + 1}`}
                      value={info}
                      onChange={(e) => handleAdditionalInfoChange(idx, e.target.value)}
                      fullWidth
                    />
                    <IconButton
                      onClick={() => removeAdditionalInfoField(idx)}
                      disabled={form.additionalInfo.length === 1}
                    >
                      <Delete />
                    </IconButton>
                  </Box>
                ))}
                <Button
                  variant="text"
                  startIcon={<Add />}
                  onClick={addAdditionalInfoField}
                >
                  Add Info
                </Button>
              </Grid>
            </Grid>
          </CardContent>
          <Divider />
          <CardActions sx={{ justifyContent: "flex-end" }}>
            <Button variant="contained" type="submit" disabled={loading}>
              {loading ? "Submitting..." : "Submit Ride"}
            </Button>
          </CardActions>
        </Card>
      </form>
      <Box mt={4}>
        <RidesList />
      </Box>
    </>
  );
}
